import { getDBClient, getProvider } from "./common";
import { type Client as DBClient } from "pg";
import { providers } from "ethers";

enum TxType {
  CommitBlocks = "CommitBlocks",
  PublishProofBlocksOnchain = "PublishProofBlocksOnchain",
  ExecuteBlocks = "ExecuteBlocks",
}

type EthTx = {
  id: number;
  nonce: number;
  from_addr: Buffer;
  tx_type: TxType;
  has_failed: boolean;
};

const LOCAL_DB =
  "postgres://postgres:notsecurepassword@localhost:5432/zksync_local";

async function getInflightTxs(client: DBClient): Promise<EthTx[]> {
  const res = await client.query<EthTx>(
    `SELECT id, nonce, from_addr, tx_type, has_failed
    FROM eth_txs
    WHERE confirmed_eth_tx_history_id IS NULL
      AND id <= (
        SELECT COALESCE(MAX(eth_tx_id), 0)
        FROM eth_txs_history
        WHERE sent_at_block IS NOT NULL
      )
    ORDER BY id`,
  );

  console.debug(`Inflight txs:
    ${res.rows.map((tx) => `(${tx.id}) ${tx.tx_type} - Nonce: ${tx.nonce}` + (tx.has_failed ? " - \x1b[1;91mFAILED\x1b[0m" : "")).join("\n")}`);
  return res.rows;
}

async function getUnsentTxs(client: DBClient): Promise<EthTx[]> {
  const res = await client.query<EthTx>(
    `SELECT id, nonce, from_addr
    FROM eth_txs
    WHERE confirmed_eth_tx_history_id IS NULL
      AND id > (
        SELECT COALESCE(MAX(eth_tx_id), 0)
        FROM eth_txs_history
        WHERE sent_at_block IS NOT NULL
      )
    ORDER BY id`,
  );

  console.debug(`Unsent txs:
    ${res.rows.map((tx) => `(${tx.id}) ${tx.tx_type} - Nonce: ${tx.nonce}` + (tx.has_failed ? " - \x1b[1;91mFAILED\x1b[0m" : "")).join("\n")}`);
  return res.rows;
}

async function deleteHistory(client: DBClient, txs: EthTx[]) {
  console.debug(
    `Deleting history for txs: ${txs.map((tx) => tx.id).join(", ")}`,
  );
  await client.query(
    `DELETE FROM eth_txs_history
    WHERE eth_tx_id = ANY($1::int[])`,
    [txs.map((tx) => tx.id)],
  );
}

async function updateTxs(
  client: DBClient,
  txs: EthTx[],
  nonces: { [address: string]: number },
) {
  for (const tx of txs) {
    console.debug(
      `Changing tx #${tx.id} putting nonce ${nonces[tx.from_addr.toString("hex")]}`,
    );
    await client.query(
      `UPDATE eth_txs
      SET nonce = $1, has_failed = 'f'
      WHERE id = $2`,
      [nonces[tx.from_addr.toString("hex")], tx.id],
    );
    nonces[tx.from_addr.toString("hex")]++;
  }
}

async function get_operator_address(
  client: DBClient,
  provider: providers.BaseProvider,
): Promise<string> {
  const tx_hash = (
    await client.query<{ tx_hash: string }>(
      `SELECT tx_hash
      FROM eth_txs_history
      WHERE confirmed_at IS NOT NULL
        AND eth_tx_id = ANY((
          SELECT id
          FROM eth_txs
          WHERE from_addr IS NULL
        ))
      LIMIT 1`,
    )
  ).rows[0].tx_hash;

  return (await provider.getTransaction(tx_hash)).from;
}

async function getCurrentNonces(
  provider: providers.BaseProvider,
  addresses: string[],
): Promise<{ [address: string]: number }> {
  let nonces: { [address: string]: number } = {};

  for (const address of addresses) {
    const nonce = await provider.getTransactionCount(address);
    nonces[address] = nonce;
    console.debug(`Address ${address} has nonce ${nonce}`);
  }

  return nonces;
}

function fail(exitCode: number, message: string, error?: Error) {
  process.env.exitCode = exitCode.toString();
  console.error(`${message}:`, error?.message);
}

export async function fixNonce(db: string, l1url: string, mainnet: boolean) {
  let client: DBClient;
  try {
    db = db || LOCAL_DB;
    client = await getDBClient(db);
  } catch (error) {
    fail(1, "Couldn't connect to DB", error);
    return;
  }

  let inflight_txs: EthTx[];
  let unsent_txs: EthTx[];
  try {
    inflight_txs = await getInflightTxs(client);
    unsent_txs = await getUnsentTxs(client);

    if (inflight_txs.length === 0 && unsent_txs.length === 0) {
      console.log("No transactions to fix");
      await client.end();
      return;
    }
  } catch (error) {
    fail(2, "Couldn't get inflight or unsent transactions", error);
    await client.end();
    return;
  }

  try {
    if (inflight_txs.length > 0) {
      await deleteHistory(client, inflight_txs);
    }
  } catch (error) {
    fail(2, "Couldn't delete txs history", error);
    await client.end();
    return;
  }

  let allTxs = inflight_txs.concat(unsent_txs);

  let nonces: { [address: string]: number };
  try {
    const provider: providers.BaseProvider = await getProvider(
      false,
      mainnet,
      l1url,
      "",
    );

    // Replace null from_addr with operator address
    if (allTxs.filter((tx) => tx.from_addr === null).length > 0) {
      const operator_address = await get_operator_address(client, provider);
      allTxs = allTxs.map((tx) => ({
        ...tx,
        from_addr: tx.from_addr || operator_address,
      }));
    }

    const uniqueAddresses = [
      ...new Set(allTxs.map((tx) => tx.from_addr.toString("hex"))),
    ];
    nonces = await getCurrentNonces(provider, uniqueAddresses);
  } catch (error) {
    fail(3, "Couldn't reach L1 Node", error);
    await client.end();
    return;
  }

  try {
    await updateTxs(client, allTxs, nonces);
  } catch (error) {
    fail(2, "Couldn't update txs", error);
    await client.end();
    return;
  }

  await client.end();

  console.log("Nonce fixed");
}
