import { Wallet, Provider, utils } from "zksync-ethers";
import { IERC20 } from "zksync-ethers/build/utils";

import * as ethers from "ethers";
import { env } from "process";
import contractAbi from "./erc20_abi.json";
import { isNumberObject, isStringObject } from "util/types";

// HTTP RPC endpoints
const L1_RPC_ENDPOINT = env.L1_RPC_URL || "http://127.0.0.1:8545";
const L2_RPC_ENDPOINT = env.L2_RPC_URL || "http://127.0.0.1:3050";

const AMOUNT_TO_PASS = env.AMOUNT_TO_PASS || "0.1";
const AMOUNT_TO_BRIDGE = env.AMOUNT_TO_BRIDGE || "100";
const AMOUNT_OF_WALLETS = 1;

const L1_RICH_PK = env.L1_RICH_PK || "0x850683b40d4a740aa6e745f889a6fdc8327be76e122f5aba645a5b02d0248db8";

const L1_RICH = {
    addr: ethers.utils.computeAddress(L1_RICH_PK),
    pk: L1_RICH_PK,
};

const getERC20Balance = async (address: string, ERC20_L1: ethers.ethers.Contract, ERC20_DECIMALS_MUL: number, ERC20_SYMBOL: string) => {
    await ERC20_L1.balanceOf(address)
        .then((balance: number) => {
            console.log(`L1 ERC20 Balance: ${balance / ERC20_DECIMALS_MUL} ${ERC20_SYMBOL}`);
            return balance
        })
        .catch(() => {
            console.error("Error fetching ERC20 balance from L1");
            return 0;
        });
    return 0;
}

const deposit = async (zkwallet: Wallet, token: string, amount: string) => {
    const txEstimate = await zkwallet.getDepositTx({
        token,
        amount: ethers.utils.parseEther(amount)
    })
    const limit = await zkwallet.provider.estimateGas(txEstimate);
    const gasLimit = Math.ceil(limit.toNumber() * 1.2);
    const tx = await zkwallet.deposit({
        token,
        amount: (ethers.utils.parseEther(amount)).sub(gasLimit),
        approveERC20: true,
        approveBaseERC20: true,
        overrides: {
            gasLimit
        }
    });
    const receipt = await tx.wait();
    console.log(`Tx: ${receipt.transactionHash}`);

    console.log("\n#####################################################\n")
    console.log(`L2 balance after deposit: ${ethers.utils.formatEther(await zkwallet.getBalance())}`)
    console.log("\n#####################################################\n")
}

const l1ERC20Transfer = async (ethwallet: ethers.Wallet, amount: string, address: string, ERC20_L1: ethers.ethers.Contract, ERC20_DECIMALS_MUL: number, ERC20_SYMBOL: string) => {
    const data = ERC20_L1.interface.encodeFunctionData("transfer", [address, ethers.utils.parseEther(amount)])
    const limit = await ethwallet.provider.estimateGas({
        to: ERC20_L1.address,
        from: ethwallet.address,
        data: data
    });
    const gasLimit = Math.ceil(limit.toNumber() * 1.2);
    const tx = await ethwallet.sendTransaction({
        to: ERC20_L1.address,
        from: ethwallet.address,
        data: data,
        gasLimit,
    });
    const receipt = await tx.wait();

    console.log("\n#####################################################\n")
    console.log(`Wallet: ${address} || Tx hash: ${receipt.transactionHash}`)
    await getERC20Balance(address, ERC20_L1, ERC20_DECIMALS_MUL, ERC20_SYMBOL);
    console.log("\n#####################################################\n")
}

async function sendMultipleTransactions(walletEthers, wallets: { address: string }[], amountForEach: string | number) {
    const amount = isNumberObject(amountForEach) ? String(amountForEach) : amountForEach;
    let nonce = await walletEthers.provider.getTransactionCount(walletEthers.address, 'latest');
    const transactionPromises: Promise<ethers.providers.TransactionResponse>[] = [];

    for (const w of wallets) {
        const tx = {
            to: w.address,
            nonce: nonce++,
            value: ethers.utils.parseEther(amount),
            gasLimit: 21000
        };

        const transactionPromise = walletEthers.sendTransaction(tx).then(async (response) => {
            const receipt = await response.wait();
            console.log(`Transaction sent: ${response.hash}, confirmed in block: ${receipt.blockNumber}`);
            return response;
        }).catch((error) => {
            console.error(`Error sending transaction to ${w.address}: ${error.message}`);
            throw error;
        });

        transactionPromises.push(transactionPromise);
    }
    await Promise.all(transactionPromises);
}


async function main() {
    // Initialize the rich wallet, ERC20 contract and providers
    const l1Provider = new ethers.providers.JsonRpcProvider(L1_RPC_ENDPOINT)
    const l2Provider = new Provider(L2_RPC_ENDPOINT);
    const richWallet = new Wallet(L1_RICH.pk, l2Provider, l1Provider);

    const walletEthers = new ethers.Wallet(L1_RICH_PK, l1Provider);
    const ERC20_L1 = new ethers.Contract(await l2Provider.getBaseTokenContractAddress(), contractAbi, walletEthers);
    const ERC20_SYMBOL: string = await ERC20_L1.symbol();
    const ERC20_DECIMALS_MUL = Math.pow(10, Number(await ERC20_L1.decimals()));

    let gasConsumed: ethers.BigNumber = 0;

    // Initialize the rich wallet.
    let wallets: Wallet[] = new Array<Wallet>();
    for (let index = 0; index < AMOUNT_OF_WALLETS; index++) {
        const pk = Wallet.createRandom().privateKey;
        const w = new Wallet(pk, l2Provider, l1Provider);
        wallets.push(w)
    }
    const amountForEach = Number(AMOUNT_TO_BRIDGE) / wallets.length;

    console.log("#####################################################\n");
    wallets.forEach((w, i) => {
        console.log(`Wallet(${i.toString().padStart(2, '0')}) addr: ${w.address} || pk: ${w.privateKey}`);
    });
    console.log("\n#####################################################\n");
    console.log(`L1 Endpoint: ${L1_RPC_ENDPOINT}`);
    console.log(`L2 Endpoint: ${L2_RPC_ENDPOINT}`);
    console.log("\n#####################################################\n");

    const erc20Balance: number = await getERC20Balance(walletEthers.address, ERC20_L1, ERC20_DECIMALS_MUL, ERC20_SYMBOL);
    if (erc20Balance <= Number(AMOUNT_TO_BRIDGE)) {
        const response = await ERC20_L1.mint(walletEthers.address, AMOUNT_TO_BRIDGE);
        const receipt = await response.wait();
    }

    let consumedL1Gas = await walletEthers.provider.getBalance(walletEthers.address);
    wallets.forEach(async w => {
        await l1ERC20Transfer(walletEthers, amountForEach, w.address, ERC20_L1, ERC20_DECIMALS_MUL, ERC20_SYMBOL);
    });
    consumedL1Gas = consumedL1Gas.sub(await walletEthers.provider.getBalance(walletEthers.address));

    console.log("ERC20 Sent on L1");
    console.log("#####################################################\n");

    const BASE_TOKEN_ADDRESS = await l2Provider.getBaseTokenContractAddress();
    //let nonce = await l1Provider.getTransactionCount(walletEthers.address);
    //let transactionPromises: Promise<ethers.providers.TransactionResponse>[] = [];
    //for (const w of wallets) {
    //    const tx = {
    //        to: w.address,
    //        nonce: nonce++,
    //        value: ethers.utils.parseEther(String(amountForEach)),
    //        gasLimit: 21000,
    //        gasPrice: await l1Provider.getGasPrice(),
    //    };
    //
    //    const transactionPromise = walletEthers.sendTransaction(tx).then(async (response) => {
    //        const receipt = await response.wait();
    //        console.log(`Transaction sent: ${response.hash}, confirmed in block: ${receipt.blockNumber}`);
    //        return response;
    //    }).catch((error) => {
    //        console.error(`Error sending transaction to ${w.address}: ${error.message}`);
    //        throw error;
    //    });
    //    transactionPromises.push(transactionPromise);
    //
    //}
    //
    //await Promise.all(transactionPromises);
    await sendMultipleTransactions(walletEthers, wallets, String(amountForEach));
}


main()
    .then()
    .catch((error) => {
        console.error(error);
        env.exitCode = "1";
    });
