import { Wallet, Provider, utils } from "zksync-ethers";
import { IERC20 } from "zksync-ethers/build/utils";
import * as ethers from "ethers";
import { env } from "process";
import { parseArgs } from "util";
import contractAbi from "./erc20_abi.json";

const { values, _positionals } = parseArgs({
    args: Bun.argv,
    options: {
        amount_to_pass: {
            type: 'string',
        },
        amount_to_bridge: {
            type: 'string',
        },
        l1_pk: {
            type: 'string',
        },
        l2_pk: {
            type: 'string',
        },
        sleep_ms: {
            type: 'string',
        },
    },
    strict: true,
    allowPositionals: true,
});

if (Object.keys(values).length !== 0) {
    console.log(values);
}

// HTTP RPC endpoints
const L1_RPC_ENDPOINT = env.L1_RPC_URL || "http://127.0.0.1:8545";
const L2_RPC_ENDPOINT = env.L2_RPC_URL || "http://127.0.0.1:3050";

const AMOUNT_TO_PASS = values.amount_to_pass || env.AMOUNT_TO_PASS || "0.1";
const AMOUNT_TO_BRIDGE = values.amount_to_bridge || env.AMOUNT_TO_BRIDGE || "100";
const SLEEP_MS = values.sleep_ms || env.SLEEP_MS || "0";

const L1_RICH_PK = values.l1_pk || env.L1_RICH_PK || "0x850683b40d4a740aa6e745f889a6fdc8327be76e122f5aba645a5b02d0248db8";

const L1_RICH = {
    addr: ethers.utils.computeAddress(L1_RICH_PK),
    pk: L1_RICH_PK,
};

const L2_PK = values.l2_pk || env.L2_PK || Wallet.createRandom().privateKey;


const L2_ACCOUNT = {
    addr: ethers.utils.computeAddress(L2_PK),
    pk: L2_PK,
};

const getERC20Balance = async (address: string, ERC20_L1: ethers.ethers.Contract, ERC20_DECIMALS_MUL: number, ERC20_SYMBOL: string) => {
    await ERC20_L1.balanceOf(address)
        .then((balance: number) => {
            console.log(`L1 ERC20 Balance: ${balance / ERC20_DECIMALS_MUL} ${ERC20_SYMBOL}`);
        })
        .catch(() => {
            console.error("Error fetching ERC20 balance from L1");
        });
}

async function main() {
    // Initialize the wallet.
    const l1provider = new ethers.providers.JsonRpcProvider(L1_RPC_ENDPOINT)
    const l2provider = new Provider(L2_RPC_ENDPOINT);
    const wallet1 = new Wallet(L1_RICH.pk, l2provider, l1provider);
    const wallet2 = new Wallet(L2_ACCOUNT.pk, l2provider, l1provider);
    const wallet3Pk = Wallet.createRandom().privateKey;
    const wallet3 = new Wallet(wallet3Pk, l2provider, l1provider);

    const sleep = Number(SLEEP_MS) || 100;

    console.log(`Running script to deposit ${AMOUNT_TO_BRIDGE}ETH in L2`);
    console.log(`Deposit ${AMOUNT_TO_BRIDGE}ETH using ${L1_RICH.addr}`);

    console.log(`L1 Endpoint: ${L1_RPC_ENDPOINT}`);
    console.log(`L2 Endpoint: ${L2_RPC_ENDPOINT}`);

    console.log("#####################################################\n");
    console.log(`L1 balance before deposit: ${ethers.utils.formatEther(await wallet1.getBalanceL1())}`);
    console.log(`L2 balance before deposit: ${ethers.utils.formatEther(await wallet1.getBalance())}`);
    console.log("\n#####################################################\n");

    if (!await l2provider.isEthBasedChain()) {
        const walletEthers = new ethers.Wallet(L1_RICH_PK, l1provider);

        const ERC20_L1 = new ethers.Contract(await l2provider.getBaseTokenContractAddress(), contractAbi, walletEthers);
        const ERC20_SYMBOL: string = await ERC20_L1.symbol();
        const ERC20_DECIMALS_MUL = Math.pow(10, Number(await ERC20_L1.decimals()));

        console.log("#####################################################\n");

        // Used locally
        await ERC20_L1.mint(await walletEthers.getAddress(), BigInt(10000 * ERC20_DECIMALS_MUL));
        await getERC20Balance(wallet1.address, ERC20_L1, ERC20_DECIMALS_MUL, ERC20_SYMBOL);
    }
    const tx = await wallet1.deposit({
        token: await l2provider.getBaseTokenContractAddress(),
        to: await wallet1.getAddress(),
        amount: ethers.utils.parseEther(String(Number(AMOUNT_TO_BRIDGE) * 2.05)),
        approveBaseERC20: true,
        approveERC20: true,
    });
    const receipt = await tx.wait();
    console.log(`Tx: ${receipt.transactionHash}`);

    console.log("\n#####################################################\n")
    console.log(`L1 balance after deposit: ${ethers.utils.formatEther(await wallet1.getBalanceL1())}`);
    console.log(`L2 balance after deposit: ${ethers.utils.formatEther(await wallet1.getBalance())}`);
    console.log("\n#####################################################\n")

    console.log(`Running script to generate transactions between two accounts in L2`);
    console.log(`With an interval between txs of ${SLEEP_MS}[ms]`);
    console.log(`Using ${AMOUNT_TO_PASS}ETH to send back and forth`);
    console.log(`Using:\naddr(1): ${L1_RICH.addr}\naddr(2): ${L2_ACCOUNT.addr}`);

    console.log("\n#####################################################\n");

    console.log("Send initial funds to the second wallet to pay the fees");

    const tx0 = await wallet1.transfer({
        to: await wallet2.getAddress(),
        amount: ethers.utils.parseEther(String(Number(AMOUNT_TO_BRIDGE) / 3)),
    });
    const receipt1 = await tx0.wait();
    console.log(`Tx(1): ${receipt1.transactionHash}`);

    const tx02 = await wallet1.transfer({
        to: await wallet3.getAddress(),
        amount: ethers.utils.parseEther(String(Number(AMOUNT_TO_BRIDGE) / 3)),
    });
    const receipt02 = await tx02.wait();
    console.log(`Tx(2): ${receipt02.transactionHash}`);

    const txFeeWithdrawal = await wallet1.transfer({
        to: "0xf2248620e8E98628b4F4a82a3f6dfe4F5993ceBa",
        amount: ethers.utils.parseEther(String(Number(AMOUNT_TO_BRIDGE) / 3)),
    });
    const receiptFeeWithdrawal = await txFeeWithdrawal.wait();
    console.log(`Tx(3): ${receiptFeeWithdrawal.transactionHash}`);
    
    while (true) {
        const tx1 = await wallet2.transfer({
            to: await wallet3.getAddress(),
            amount: ethers.utils.parseEther(AMOUNT_TO_PASS),
        });
        const receipt1 = await tx1.wait();
        console.log(`Tx(1): ${receipt1.transactionHash}`);

        const tx2 = await wallet3.transfer({
            to: await wallet2.getAddress(),
            amount: ethers.utils.parseEther(AMOUNT_TO_PASS),
        });
        const receipt2 = await tx2.wait();
        console.log(`Tx(2): ${receipt2.transactionHash}`);
        console.log(`addr(1): ${wallet3.address} balance: ${ethers.utils.formatEther(await wallet3.getBalance())}`);
        console.log(`addr(2): ${wallet2.address} balance: ${ethers.utils.formatEther(await wallet2.getBalance())}`);
        console.log("\n#####################################################\n")
        await Bun.sleep(sleep);
    }
}

main()
    .then()
    .catch((error) => {
        console.error(error);
        env.exitCode = "1";
    });
