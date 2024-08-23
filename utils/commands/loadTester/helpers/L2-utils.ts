import { Wallet } from "zksync-ethers";
import * as ethers from "ethers";

export async function l1ToL2ERC20Deposit(
    zkWallet: Wallet,
    token: string,
    amount: string
) {
    return zkWallet
        .deposit({
            token,
            amount: ethers.utils.parseEther(amount),
            approveERC20: true,
            approveBaseERC20: true,
        }).then(async (response) => {
            const receipt = await response.wait();
            const msg =
                `#####################################################
                Wallet: ${zkWallet.address}
                Tx hash: ${receipt.transactionHash}
                L2 balance after deposit: ${ethers.utils.formatEther(await zkWallet.getBalance())}
                #####################################################`;
            console.log(msg.split('\n').map(line => line.trim()).join('\n'));
            return response;
        }).catch((error) => {
            throw error;
        });
};



export async function sendMultipleL2BaseTokenDeposits(
    zkWallet: Wallet,
    wallets: Wallet[],
    amountForEach: string | number
) {
    const amount =
        typeof amountForEach == "number" ? amountForEach.toString() : amountForEach;

    const transactionPromises: Promise<ethers.providers.TransactionResponse>[] =
        [];
    const baseTokenAddress = await zkWallet.provider.getBaseTokenContractAddress();
    for (const w of wallets) {
        const transactionPromise = l1ToL2ERC20Deposit(
            w,
            baseTokenAddress,
            amount
        );
        transactionPromises.push(transactionPromise);
    }
    await Promise.all(transactionPromises);
}


export async function sendMultipleL2Transfers(
    wallets: Wallet[],
    amountForEach: string | number
) {
    const amount =
        typeof amountForEach == "number" ? amountForEach.toString() : amountForEach;

    const transactionPromises: Promise<ethers.providers.TransactionResponse>[] =
        [];

    const randomWallets: Wallet[] = [];
    for (let index = 0; index < wallets.length; index++) {
        const pk = Wallet.createRandom().privateKey;
        const w = new Wallet(pk, wallets[0].provider, wallets[0].providerL1);
        randomWallets.push(w);
    }

    console.log("\n#####################################################\n");
    randomWallets.forEach((w, i) => {
        console.log(
            `Wallet(${i.toString().padStart(2, "0")}) addr: ${w.address} || pk: ${w.privateKey}`
        );
    });
    console.log("\n#####################################################\n");

    for (let i = 0; i < wallets.length; i++) {
        const transactionPromise = wallets[i].transfer({
            to: randomWallets[i].address,
            amount: ethers.utils.parseEther(amount)
        }).then(async (response) => {
            const receipt = await response.wait();
            const msg =
                `#####################################################
                (to): ${randomWallets[i].address} balance: ${ethers.utils.formatEther(await randomWallets[i].getBalance())}
                Tx hash: ${receipt.transactionHash}
                #####################################################`;
            console.log(msg.split('\n').map(line => line.trim()).join('\n'));
            return response;
        }).catch((error) => {
            throw error;
        });
        transactionPromises.push(transactionPromise);
    }
    await Promise.all(transactionPromises);
}
