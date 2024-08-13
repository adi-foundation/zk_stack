import { Wallet } from "zksync-ethers";
import * as ethers from "ethers";

export async function l1ToL2ERC20Deposit(
    zkWallet: Wallet,
    ethWallet: ethers.Wallet, // Used to get allowance
    token: string,
    amount: string
) {
    // Check Allowance [wip] - This breaks the nonce
    //const ERC20_L1 = new ethers.Contract(token, IERC20, ethWallet);
    //let allowance = await ERC20_L1.allowance(ethWallet.address, ethWallet.address)
    //    .then(async (allowance) => {
    //        return ethers.utils.formatEther(allowance);
    //    })
    //    .catch((_error) => {
    //        return ethers.utils.formatEther(0);
    //    });
    //
    //const value = ethers.utils.parseEther(String(Number(amount) * 1.01));
    //if (ethers.utils.parseEther(allowance).lt(value)) {
    //    const approveTx = await ERC20_L1.approve(ethWallet.address, value);
    //    await approveTx.wait();
    //}
    //
    //
    //allowance = await ERC20_L1.allowance(ethWallet.address, ethWallet.address)
    //    .then(async (allowance) => {
    //        return ethers.utils.formatEther(allowance);
    //    })
    //    .catch((_error) => {
    //        return ethers.utils.formatEther(0);
    //    });
    //
    //console.log(`Current allowance: ${allowance}`);
    // --------------------------------
    console.log(`[TODO: FIX gasLimit calculations]`);
    const txEstimate = await zkWallet.getDepositTx({
        token,
        amount: ethers.utils.parseEther(amount),
    });
    // When the gas is estimated, it fails
    // const limit = await zkWallet.estimateGasDeposit(txEstimate);
    // TODO: maybe it is not necessary to multiply the gasLimit in order to have some headroom
    //const gasLimit = Math.ceil(limit.toNumber() * 1.2);
    return zkWallet
        .deposit({
            token,
            amount: ethers.utils.parseEther(amount),
            approveERC20: true,
            approveBaseERC20: true,
        }).then(async (response) => {
            const receipt = await response.wait();
            console.log("#####################################################");
            console.log(
                `Wallet: ${zkWallet.address}\nTx hash: ${receipt.transactionHash}`
            );
            console.log(
                `L2 balance after deposit: ${ethers.utils.formatEther(await zkWallet.getBalance())}`
            );
            console.log("#####################################################");
            return response;
        }).catch((error) => {
            throw error;
        });
};



export async function sendMultipleL2BaseTokenDeposits(
    zkWallet: Wallet,
    ethWallet: ethers.Wallet,
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
            ethWallet,
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

    console.log("#####################################################\n");
    randomWallets.forEach((w, i) => {
        console.log(
            `Wallet(${i.toString().padStart(2, "0")}) addr: ${w.address} || pk: ${w.privateKey}`
        );
    });

    for (let i = 0; i < wallets.length; i++) {
        console.log(`[TODO: ADD gasLimit calculations]`);
        const transactionPromise = wallets[i].transfer({
            to: randomWallets[i].address,
            amount: ethers.utils.parseEther(amount)
        }).then(async (response) => {
            const receipt = await response.wait();
            console.log("#####################################################");
            console.log(
                `(to):\nWallet ${randomWallets[i].address}: ${ethers.utils.formatEther(await randomWallets[i].getBalance())}\nTx hash: ${receipt.transactionHash}`
            );
            console.log("#####################################################");
            return response;
        }).catch((error) => {
            throw error;
        });
        transactionPromises.push(transactionPromise);
    }
    await Promise.all(transactionPromises);
}
