import { ethers, parseEther } from "ethers";
import { utils, Provider as ZkSyncProvider, Wallet as ZkSyncWallet } from 'zksync-ethers';
import { MsgCode } from '../models/message';
import { Operator, OperatorType } from "../models/operator";
import {
    ETH_SENDER_SENDER_PROOF_SENDING_MODE,
    L1_RPC_ENDPOINT,
    L2_RPC_ENDPOINT,
    WAITING_COMMIT_HASH_TIME_IN_MS,
    WAITING_EXECUTED_HASH_TIME_IN_MS,
    WAITING_PROVE_HASH_TIME_IN_MS_WITH_PROVER_IN_MS,
    WAITING_PROVE_HASH_TIME_IN_MS_WITHOUT_PROVER_IN_MS
} from "./config";
import { sendSlackMessage, slackError, slackSent } from './slack';
import { italic } from "./utils";

const l1_provider = new ethers.JsonRpcProvider(L1_RPC_ENDPOINT);
const l2_provider = new ZkSyncProvider(L2_RPC_ENDPOINT);
const defaultWaitTime = 30 * 1000;

export async function getBalanceL1(address: string) {
    const balance = parseFloat(ethers.formatEther(await l1_provider.getBalance(address)));
    return balance;
}

export async function getBalanceL2(address: string) {
    const balance = parseFloat(ethers.formatEther(await l2_provider.getBalance(address)));
    return balance;
}

export async function getLastBlockL2() {
    const currentBlock = await l2_provider.getBlockNumber();
    return currentBlock;
}

export async function waitForTransactionStatus(txHash: string, txType: string, messageStack: string[]) {
    const receipt = await l1_provider.getTransactionReceipt(txHash);
    if (!receipt || !receipt.status) {
        await new Promise(resolve => setTimeout(resolve, defaultWaitTime));
        return waitForTransactionStatus(txHash, txType, messageStack);
    } else {
        const status = receipt.status;
        if (status === 0) {
            const errorMessage = `${MsgCode.ERROR} Error producing a batch: ${txType} tx failed ${italic(txHash)}`;
            await sendSlackMessage(errorMessage)
                ? messageStack.push(errorMessage + slackSent)
                : messageStack.push(errorMessage + slackError);
            return false;
        } else {
            return true;
        }
    }
}

export async function waitForCommitHash(batchNumber: number, totalTime: number, messageStack: string[]): Promise<boolean> {
    const details = await l2_provider.getL1BatchDetails(batchNumber);
    let commitHash = details.commitTxHash;
    if (!commitHash) {
        await new Promise(resolve => setTimeout(resolve, WAITING_COMMIT_HASH_TIME_IN_MS));
        return waitForCommitHash(batchNumber, totalTime + WAITING_COMMIT_HASH_TIME_IN_MS, messageStack);
    } else {
        commitHash = commitHash!;
        messageStack.push(`${MsgCode.INFO} Commit hash: ${commitHash}. Waited ${totalTime / 1000}s`);
        const success = await waitForTransactionStatus(commitHash, "COMMIT", messageStack);
        return success;
    }
}

export async function waitForProveHash(batchNumber: number, totalTime: number, messageStack: string[]): Promise<boolean> {
    let waitingTime = WAITING_PROVE_HASH_TIME_IN_MS_WITHOUT_PROVER_IN_MS;
    if (ETH_SENDER_SENDER_PROOF_SENDING_MODE === "OnlyRealProofs") {
        waitingTime = WAITING_PROVE_HASH_TIME_IN_MS_WITH_PROVER_IN_MS;
    }
    const details = await l2_provider.getL1BatchDetails(batchNumber);
    let proveHash = details.proveTxHash;
    if (!proveHash) {
        await new Promise(resolve => setTimeout(resolve, waitingTime));
        return waitForProveHash(batchNumber, totalTime + waitingTime, messageStack);
    } else {
        proveHash = proveHash!;
        messageStack.push(`${MsgCode.INFO} Prove hash: ${proveHash}. Waited ${totalTime / 1000}s`);
        const success = await waitForTransactionStatus(proveHash, "PROVE", messageStack);
        return success;
    }
}

export async function waitForExecuteHash(batchNumber: number, totalTime: number, messageStack: string[]): Promise<boolean> {
    const details = await l2_provider.getL1BatchDetails(batchNumber);
    let executeHash = details.executeTxHash;

    if (!executeHash) {
        await new Promise(resolve => setTimeout(resolve, WAITING_EXECUTED_HASH_TIME_IN_MS));
        return waitForExecuteHash(batchNumber, totalTime + WAITING_EXECUTED_HASH_TIME_IN_MS, messageStack);
    } else {
        executeHash = executeHash!;
        messageStack.push(`${MsgCode.INFO} Execute hash: ${executeHash}. Waited ${totalTime / 1000}s`);
        const success = await waitForTransactionStatus(executeHash, "EXECUTE", messageStack);
        return success;
    }
}

export async function waitForBatchNumber(txHash: string, totalTime: number): Promise<number> {
    const receipt = await l2_provider.getTransactionReceipt(txHash);
    if (!receipt || !receipt.l1BatchNumber) {
        await new Promise(resolve => setTimeout(resolve, defaultWaitTime));
        return waitForBatchNumber(txHash, totalTime + defaultWaitTime);
    } else {
        return receipt.l1BatchNumber!;
    }
}

async function checkEnoughFunds(operator: Operator, messageStack: string[]) {
    const l1Balance = await operator.balanceL1();
    messageStack.push(`${MsgCode.INFO} ${OperatorType.TX_SENDER}: ${operator.address} balance is ${l1Balance}`);

    if (l1Balance < 0.5) {
        const errorMessage = `${MsgCode.ERROR} ${OperatorType.TX_SENDER}: ${operator.address} has not enough balance in L1. Balance: ${l1Balance}`;
        await sendSlackMessage(errorMessage)
            ? messageStack.push(errorMessage + slackSent)
            : messageStack.push(errorMessage + slackError);
        return false;
    }

    return true;
}

export async function deposit(operator: Operator, messageStack: string[]): Promise<[boolean, number]> {
    const enoughFunds = await checkEnoughFunds(operator, messageStack);
    if (enoughFunds) {
        const sender = new ZkSyncWallet(operator.privateKey!, l2_provider, l1_provider);
        const transferAmount = "0.00000000001";
        messageStack.push(`${MsgCode.INFO} ${OperatorType.TX_SENDER}: ${operator.address} is going to deposit ${transferAmount} to itself`);

        const depositTransaction = {
            token: utils.ETH_ADDRESS,
            to: sender.address,
            amount: parseEther(transferAmount)
        };

        const depositTx = await sender.deposit(depositTransaction);
        const response = await depositTx.wait();
        messageStack.push(`${MsgCode.INFO} Transaction hash: ${response.hash}`);
        const batchNumber = await waitForBatchNumber(response.hash, 0);
        messageStack.push(`${MsgCode.INFO} Transaction batch number: ${batchNumber}`);
        return [true, batchNumber];
    } else {
        return [false, -1];
    }
}
