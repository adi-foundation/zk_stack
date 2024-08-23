import { Wallet } from "zksync-ethers";
import * as ethers from "ethers";

export async function getERC20Balance(
    address: string,
    ERC20_L1: ethers.ethers.Contract,
    ERC20_DECIMALS_MUL: number,
    ERC20_SYMBOL: string
) {
    return await ERC20_L1.balanceOf(address)
        .then((balance: number) => {
            console.log(
                `L1 ERC20 Balance: ${balance / ERC20_DECIMALS_MUL} ${ERC20_SYMBOL}`
            );
            return balance / ERC20_DECIMALS_MUL;
        })
        .catch(() => {
            console.error("Error fetching ERC20 balance from L1");
            return 0;
        });
};

export async function l1ERC20Transfer(
    ethwallet: ethers.Wallet,
    nonce: number,
    amount: string | number,
    address: string,
    ERC20_L1: ethers.ethers.Contract
) {
    const parsedAmount = typeof amount == "number" ? amount.toString() : amount;
    const data = ERC20_L1.interface.encodeFunctionData("transfer", [
        address,
        ethers.utils.parseEther(parsedAmount),
    ]);
    const limit = await ethwallet.provider.estimateGas({
        to: ERC20_L1.address,
        from: ethwallet.address,
        nonce,
        data: data,
    });
    const gasLimit = Math.ceil(limit.toNumber() * 1.2);

    return ethwallet
        .sendTransaction({
            to: ERC20_L1.address,
            from: ethwallet.address,
            nonce,
            data: data,
            gasLimit,
        })
        .then(async (response) => {
            const receipt = await response.wait();
            const msg =
                `#####################################################
                Wallet: ${ethwallet.address}
                Tx hash: ${receipt.transactionHash}
                #####################################################`;
            console.log(msg.split('\n').map(line => line.trim()).join('\n'));
            return response;
        })
        .catch((error) => {
            throw error;
        });
};

export async function sendMultipleL1ERC20Transfers(
    walletEthers: ethers.Wallet,
    wallets: Wallet[],
    amountForEach: string | number,
    ERC20_L1: ethers.Contract
) {
    const amount =
        typeof amountForEach == "number" ? amountForEach.toString() : amountForEach;
    const transactionPromises: Promise<ethers.providers.TransactionResponse>[] =
        [];
    let nonce = await walletEthers.provider.getTransactionCount(
        walletEthers.address,
        "latest"
    );
    for (const w of wallets) {
        const transactionPromise = l1ERC20Transfer(
            walletEthers,
            nonce++,
            amount,
            w.address,
            ERC20_L1
        );
        transactionPromises.push(transactionPromise);
    }
    await Promise.all(transactionPromises);
}

export async function sendMultipleL1ETHTransfers(
    walletEthers: ethers.Wallet,
    wallets: Wallet[],
    amountForEach: string | number
) {
    const amount =
        typeof amountForEach == "number" ? amountForEach.toString() : amountForEach;
    let nonce = await walletEthers.provider.getTransactionCount(
        walletEthers.address,
        "latest"
    );
    const transactionPromises: Promise<ethers.providers.TransactionResponse>[] =
        [];

    for (const w of wallets) {
        const tx = {
            to: w.address,
            nonce: nonce++,
            value: ethers.utils.parseEther(amount),
            gasLimit: 21000,
            gasPrice: await walletEthers.provider.getGasPrice(),
        };

        const transactionPromise = walletEthers
            .sendTransaction(tx)
            .then(async (response) => {
                const receipt = await response.wait();
                const msg =
                    `#####################################################
                    Wallet: ${w.address}
                    Tx hash: ${receipt.transactionHash}
                    #####################################################`;
                console.log(msg.split('\n').map(line => line.trim()).join('\n'));
                return response;
            })
            .catch((error) => {
                throw error;
            });

        transactionPromises.push(transactionPromise);
    }
    await Promise.all(transactionPromises);
}
