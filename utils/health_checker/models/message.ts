import { L2_EXPLORER_URL } from "../src/config";
import { bold, italic } from "../src/utils";
import { Operator, Threshold, ThresholdMovement } from "./operator";

export const enum MsgCode {
    INFO = "\u2139",  // ℹ️
    WARNING = "\u26A0",  // ⚠️
    ERROR = "\u274C", // ❌
    SUCCESS = "\u2705",
}

export const jobNonceMsg = (jobName: string, nonce: number, format: boolean, msg_c = MsgCode.INFO) => {
    let msg_code = msg_c.toString();
    let header = `${msg_code}: ${jobName} job`

    if (format) {
        header = bold(header);
    }
    return `${header}: This is the ${nonce} time(s) it's been executed.`;
} 

export const operatorBalanceMsg = async (operators: Operator[], msg_c: MsgCode = MsgCode.INFO) => {
    const initialMessage = bold(`${msg_c} Operator Balances Report ${msg_c}`);
    const messages = [initialMessage];
    for (const operator of operators) {
        const balanceL1 = await operator.balanceL1();
        const message = `• ${operator.type} Operator balance: ${bold(balanceL1.toFixed(2))} ETH (${italic(operator.address)})`;
        messages.push(message);
    }
    return messages;
}

export const thresholdMovementMsg = (operator: Operator, movement: ThresholdMovement, last: Threshold, balance: number) => {
    if (movement === ThresholdMovement.DECREASE) {
        return `${MsgCode.ERROR}: ${operator.type} balance has decreased from (${last.low}, ${last.high}) to ${balance.toFixed(2)} ETH (Address: ${operator.address})`;
    } else if (movement === ThresholdMovement.INCREASE) {
        return `${MsgCode.WARNING}: ${operator.type} balance has increased from (${last.low}, ${last.high}) to ${bold(balance.toFixed(2))} ETH (Address: ${italic(operator.address)})`;
    } else if (balance === 0) {
        return `${MsgCode.ERROR}: Critical error - ${operator.type} balance is zero (Address: ${italic(operator.address)})`;
    } else {
        return "";
    }
}

export const operatorThresholdMsg = (operatorsMovements: string[], msg_code = MsgCode.INFO) => {
    if (operatorsMovements.length === 0) {
        return [];
    }
    const initialMessage = bold(`${msg_code} Threshold-Based Monitoring Report ${msg_code}`);
    const messages = [initialMessage];
    for (const movement of operatorsMovements) {
        messages.push("• " + movement)
    }
    return messages;
}

export const advanceBlockchainMsg = (batchNumber: number, executionTime: number, msg_c = MsgCode.SUCCESS) => {
     return [
        `${bold(msg_c)} The chain has manually advanced correctly: ${L2_EXPLORER_URL}/batch/${batchNumber}. Total time: ${executionTime}s`,

    ];
}
