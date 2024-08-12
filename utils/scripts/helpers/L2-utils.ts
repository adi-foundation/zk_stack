import { Wallet } from "zksync-ethers";
import * as ethers from "ethers";
import { IERC1271, IERC20 } from "zksync-ethers/build/utils";

export async function l1ToL2ERC20Deposit(
    zkWallet: Wallet,
    nonce: number,
    token: string,
    amount: string
) {
    // Check Allowance [wip]
    const ERC20_L1 = new ethers.Contract(token, IERC20, zkWallet);
    let allowance = ERC20_L1.allowance(token, zkWallet.address)
        .then(async (allowance) => {
            return allowance;
        })
        .catch((_error) => {
            return 0;
        });

    if (allowance <= amount) {
        const approveTx = await ERC20_L1.approve(zkWallet.address, ethers.utils.parseEther(String(Number(amount) * 1.05)));
        await approveTx.wait();
    }

    allowance = ERC20_L1.allowance(token, zkWallet.address)
        .then(async (allowance) => {
            return allowance;
        })
        .catch((_error) => {
            return 0;
        });

    console.log(`Current allowance: ${ethers.utils.formatEther(allowance)}`);
    // --------------------------------

    const txEstimate = await zkWallet.getDepositTx({
        token,
        to: zkWallet.address,
        amount: ethers.utils.parseEther(amount)
    });
    const limit = await zkWallet.estimateGasDeposit(txEstimate);
    // TODO: maybe it is not necessary to multiply the gasLimit in order to have some headroom
    console.log(`[TODO: FIX gasLimit calculations`);
    const gasLimit = Math.ceil(limit.toNumber() * 1.2);
    return zkWallet
        .deposit({
            token,
            amount: ethers.utils.parseEther(amount).sub(gasLimit),
            approveERC20: true,
            approveBaseERC20: true,
            overrides: {
                nonce,
            },
        })
        .then(async (response) => {
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
        })
        .catch((error) => {
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
    let nonce = await zkWallet.providerL1!.getTransactionCount(
        zkWallet.address,
        "latest"
    );
    const transactionPromises: Promise<ethers.providers.TransactionResponse>[] =
        [];
    const baseTokenAddress = await zkWallet.provider.getBaseTokenContractAddress();
    for (const w of wallets) {
        const transactionPromise = l1ToL2ERC20Deposit(
            w,
            nonce++,
            baseTokenAddress,
            amount
        );
        transactionPromises.push(transactionPromise);
    }
    await Promise.all(transactionPromises);
}
