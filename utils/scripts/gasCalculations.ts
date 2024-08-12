import { Wallet, Provider } from "zksync-ethers";

import * as ethers from "ethers";
import { env } from "process";
import contractAbi from "./erc20_abi.json";
import { helpers } from "./helpers";

// HTTP RPC endpoints
const L1_RPC_ENDPOINT = env.L1_RPC_URL || "http://127.0.0.1:8545";
const L2_RPC_ENDPOINT = env.L2_RPC_URL || "http://127.0.0.1:3050";

const AMOUNT_TO_BRIDGE = env.AMOUNT_TO_BRIDGE || "100";
const AMOUNT_OF_WALLETS = 1;

const L1_RICH_PK =
    env.L1_RICH_PK ||
    "0x850683b40d4a740aa6e745f889a6fdc8327be76e122f5aba645a5b02d0248db8";

const L1_RICH = {
    addr: ethers.utils.computeAddress(L1_RICH_PK),
    pk: L1_RICH_PK,
};

async function main() {
    // Initialize the rich wallet, ERC20 contract and providers
    const l1Provider = new ethers.providers.JsonRpcProvider(L1_RPC_ENDPOINT);
    const l2Provider = new Provider(L2_RPC_ENDPOINT);
    const zkWallet = new Wallet(L1_RICH.pk, l2Provider, l1Provider);

    const walletEthers = new ethers.Wallet(L1_RICH_PK, l1Provider);
    const ERC20_L1 = new ethers.Contract(
        await l2Provider.getBaseTokenContractAddress(),
        contractAbi,
        walletEthers
    );
    const ERC20_SYMBOL: string = await ERC20_L1.symbol();
    const ERC20_DECIMALS_MUL = Math.pow(10, Number(await ERC20_L1.decimals()));

    // Initialize the rich wallet.
    let wallets: Wallet[] = new Array<Wallet>();
    for (let index = 0; index < AMOUNT_OF_WALLETS; index++) {
        const pk = Wallet.createRandom().privateKey;
        const w = new Wallet(pk, l2Provider, l1Provider);
        wallets.push(w);
    }
    const amountForEach = Number(AMOUNT_TO_BRIDGE) / wallets.length;

    console.log("#####################################################\n");
    wallets.forEach((w, i) => {
        console.log(
            `Wallet(${i.toString().padStart(2, "0")}) addr: ${w.address} || pk: ${w.privateKey}`
        );
    });
    console.log("\n#####################################################\n");
    console.log(`L1 Endpoint: ${L1_RPC_ENDPOINT}`);
    console.log(`L2 Endpoint: ${L2_RPC_ENDPOINT}`);
    console.log("\n#####################################################\n");

    const erc20Balance: number = await helpers.l1.getERC20Balance(
        walletEthers.address,
        ERC20_L1,
        ERC20_DECIMALS_MUL,
        ERC20_SYMBOL
    );
    if (erc20Balance <= Number(AMOUNT_TO_BRIDGE)) {
        const response = await ERC20_L1.mint(
            walletEthers.address,
            BigInt(Number(AMOUNT_TO_BRIDGE) * ERC20_DECIMALS_MUL)
        );
        const receipt = await response.wait();
        console.log(
            `${AMOUNT_TO_BRIDGE} Minted ${ERC20_SYMBOL}, txHash: ${receipt.transactionHash}`
        );
        await helpers.l1.getERC20Balance(
            walletEthers.address,
            ERC20_L1,
            ERC20_DECIMALS_MUL,
            ERC20_SYMBOL
        );
    }

    let consumedL1Gas = await walletEthers.provider.getBalance(
        walletEthers.address
    );
    console.log("=====================================================");
    console.log(`Send ETH on L1`);
    await helpers.l1.sendMultipleL1ETHTransfers(walletEthers, wallets, amountForEach);
    console.log("=====================================================");
    console.log("Send ERC20 on L1");
    await helpers.l1.sendMultipleL1ERC20Transfers(
        walletEthers,
        wallets,
        amountForEach,
        ERC20_L1
    );
    console.log("=====================================================");

    consumedL1Gas = consumedL1Gas.sub(
        await walletEthers.provider.getBalance(walletEthers.address)
    );
    console.log("ERC20 Sent on L1");
    console.log(
        `[TODO: FIX gas consumption calculations] Consumed L1 Gas: ${ethers.utils.formatEther(consumedL1Gas.sub(ethers.utils.parseEther(AMOUNT_TO_BRIDGE)))}`
    );

    console.log("=====================================================");
    console.log("Deposit BaseToken L1->L2");
    await helpers.l2.sendMultipleL2BaseTokenDeposits(zkWallet, wallets, amountForEach / 2);
    console.log("=====================================================");
}

main()
    .then()
    .catch((error) => {
        console.error(error);
        env.exitCode = "1";
    });
