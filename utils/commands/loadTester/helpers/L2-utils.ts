import { Wallet } from "zksync-ethers";
import * as ethers from "ethers";

export async function l1ToL2ERC20Deposit(
    zkWallet: Wallet,
    to: string,
    token: string,
    amount: string
) {
    return zkWallet
        .deposit({
            token,
            to,
            amount: ethers.utils.parseEther(amount),
            approveERC20: true,
            approveBaseERC20: true,
        }).then(async (response) => {
            const receipt = await response.wait();
            const msg =
                `#####################################################
                Wallet: ${to}
                Tx hash: ${receipt.transactionHash}
                L2 balance after deposit: ${ethers.utils.formatEther(await zkWallet.provider.getBalance(to))}
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
            w.address,
            baseTokenAddress,
            amount
        );
        transactionPromises.push(transactionPromise);
    }
    await Promise.all(transactionPromises);
}


export async function sendMultipleL2Transfers(
    richWallet: Wallet,
    wallets: Wallet[],
    amountForEach: string | number
) {
    const amount =
        typeof amountForEach == "number" ? amountForEach.toString() : amountForEach;

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
        await richWallet.transfer({
            to: wallets[i].address,
            amount: ethers.utils.parseEther(amount)
        }).then(async (response) => {
            const receipt = await response.wait();
            const msg =
                `#####################################################
                (to): ${wallets[i].address} balance: ${ethers.utils.formatEther(await wallets[i].getBalance())}
                Tx hash: ${receipt.transactionHash}
                #####################################################`;
            console.log(msg.split('\n').map(line => line.trim()).join('\n'));
            return response;
        }).catch((error) => {
            throw error;
        });
    }

    for (let i = 0; i < wallets.length; i++) {
        await wallets[i].transfer({
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
    }

    console.log("Send funds back to the Rich Wallet in L2");

    const transactionPromisesBack: Promise<ethers.providers.TransactionResponse>[] =
        [];
    for (let i = 0; i < randomWallets.length; i++) {
        // Not ideal, gas calculations has to be performed
        const amountMinusGasAndFees = String(Number(amount) * 0.9);
        const transactionPromise = randomWallets[i].transfer({
            to: richWallet.address,
            amount: ethers.utils.parseEther(amountMinusGasAndFees)
        }).then(async (response) => {
            const receipt = await response.wait();
            const msg =
                `#####################################################
                (to): ${richWallet.address} balance: ${ethers.utils.formatEther(await randomWallets[i].provider.getBalance(richWallet.address))}
                Tx hash: ${receipt.transactionHash}
                #####################################################`;
            console.log(msg.split('\n').map(line => line.trim()).join('\n'));
            return response;
        }).catch((error) => {
            throw error;
        });
        transactionPromisesBack.push(transactionPromise);
    }
    return Promise.all(transactionPromisesBack);
}
