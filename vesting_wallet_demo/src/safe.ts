import SafeApiKit from "@safe-global/api-kit";
import Safe from "@safe-global/protocol-kit";
import { OperationType } from "@safe-global/safe-core-sdk-types";
import { Command } from "commander";
import { TransactionResponse } from "ethers";
import { TransactionReceipt } from "ethers";
import { ethers } from "ethers";

type CommonOptions = {
    safeAddress: string,
    rpcUrl: string,
    ownerPrivateKey: string
};

type CreateSafeTxOptions = {
    to: string,
    calldata: string
} & CommonOptions;

type SignSafeTxOptions = {
    safeTxHash: string
} & CommonOptions;

type ExecuteSafeTxOptions = SignSafeTxOptions;

async function proposeSafeTxAction({to, calldata, safeAddress, rpcUrl, ownerPrivateKey}: CreateSafeTxOptions) {
    let safeOwner = new ethers.Wallet(ownerPrivateKey);

    const apiKit = new SafeApiKit({
        chainId: BigInt(11155111)
    })
      
    const protocolKitOwner = await Safe.init({
        provider: rpcUrl,
        signer: ownerPrivateKey,
        safeAddress: safeAddress
    })
    
    const safeTransactionData = {
        to: to,
        value: "0",
        data: calldata,
        operation: OperationType.Call
    }
    
    const safeTransaction = await protocolKitOwner.createTransaction({
        transactions: [safeTransactionData],
    })
    
    const safeTxHash = await protocolKitOwner.getTransactionHash(safeTransaction)
    const signature = await protocolKitOwner.signHash(safeTxHash)
    
    await apiKit.proposeTransaction({
      safeAddress: safeAddress,
      safeTransactionData: safeTransaction.data,
      safeTxHash,
      senderAddress: safeOwner.address,
      senderSignature: signature.data
    })
    const transaction = await apiKit.getTransaction(safeTxHash)
    console.log("Safe transaction proposed: ", transaction.safeTxHash)
    console.log("https://app.safe.global/transactions/queue?safe=sep:0x50244ccEd795263167e9EEC0DF49e4c26EFD7DD8")
}

async function signSafeTxAction({safeTxHash, safeAddress, rpcUrl, ownerPrivateKey}: ExecuteSafeTxOptions) {
    const apiKit = new SafeApiKit({
        chainId: BigInt(11155111)
    })
      
    const protocolKitOwner = await Safe.init({
        provider: rpcUrl,
        signer: ownerPrivateKey,
        safeAddress: safeAddress
    })
    
    const signature = await protocolKitOwner.signHash(safeTxHash)
    
    // Confirm the Safe transaction
    const signatureResponse = await apiKit.confirmTransaction(
        safeTxHash,
        signature.data
    )
    
    console.log(`Safe transaction signed: ${signatureResponse}`)
}

async function executeSafeTxAction({safeTxHash, safeAddress, rpcUrl, ownerPrivateKey}: ExecuteSafeTxOptions) {
    const apiKit = new SafeApiKit({
        chainId: BigInt(11155111)
    })
      
    const protocolKit = await Safe.init({
        provider: rpcUrl,
        signer: ownerPrivateKey,
        safeAddress: safeAddress
    })
      
    const safeTransaction = await apiKit.getTransaction(safeTxHash);
    const executeTxResponse = await protocolKit.executeTransaction(safeTransaction);
    const receipt = executeTxResponse.transactionResponse as TransactionResponse;
      
    console.log(`Safe transaction executed: https://sepolia.etherscan.io/tx/${receipt.hash}`);
}

async function main() {
    const safeCommand = new Command('safe');

    safeCommand
        .command('propose')
        .description('Propose a new Safe transaction')
        .option('-t, --to <address>', 'The address of the recipient')
        .option('-c, --calldata <data>', 'The calldata for the transaction')
        .option('--safe-address <address>', 'The address of the Safe')
        .option('--rpc-url <url>', 'The RPC URL of the network')
        .option('--owner-private-key <key>', 'The private key of the signer (must be a Safe owner)')
        .action(proposeSafeTxAction);

    safeCommand
        .command('sign')
        .description('Sign a Safe transaction')
        .option('--safe-tx-hash <hash>', 'The hash of the Safe transaction')
        .option('--safe-address <address>', 'The address of the Safe')
        .option('--rpc-url <url>', 'The RPC URL of the network')
        .option('--private-key <key>', 'The private key of the signer (must be a Safe owner)')
        .action(signSafeTxAction);

    safeCommand
        .command('execute')
        .description('Execute a Safe transaction')
        .option('--safe-tx-hash <hash>', 'The hash of the Safe transaction to execute')
        .option('--safe-address <address>', 'The address of the Safe')
        .option('--rpc-url <url>', 'The RPC URL of the network')
        .option('--owner-private-key <key>', 'The private key of the signer (must be a Safe owner)')
        .action(executeSafeTxAction);

    await safeCommand.parseAsync(process.argv);
}
      
main()
    .then(() => process.exit(0))
    .catch((err) => {
        console.error("Error:", err);
        process.exit(1);
    });
      