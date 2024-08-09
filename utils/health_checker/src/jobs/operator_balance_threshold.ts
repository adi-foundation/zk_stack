import { jobNonceMsg, operatorThresholdMsg, thresholdMovementMsg } from "../../models/message";
import { Operator, OperatorType, Threshold, ThresholdMovement } from "../../models/operator";
import { BLOBS_OPERATOR_ADDRESS, COMMIT_OPERATOR_ADDRESS, THRESHOLDS } from "../config";
import { sendSlackMessage, slackError, slackSent } from "../slack";
import { flushMessageStack } from "../utils";

// Global variable to store operator states
let operatorStates = {};

let operatorBalanceThresholdsNonce = 1;
let name = "Thresholds Balance Check";

async function updateThreshold(operator: Operator, messageStack: string[]): Promise<[ThresholdMovement, number, Threshold]> {
    const balance = await operator.balanceL1();

    const [newLow, newHigh] = THRESHOLDS.reduce((acc, threshold, index, array) => {
        if (balance >= threshold) {
            acc[0] = threshold;
            acc[1] = array[index + 1] || threshold;
        }
        return acc;
    }, [0, THRESHOLDS[0]]);

    const last = operatorStates[operator.address] || { low: 0, high: 0 };
    let movement = ThresholdMovement.NONE;
    if (last.low !== newLow || last.high !== newHigh) {
        if (balance < last.low) {
            movement = ThresholdMovement.DECREASE;
        } else if (balance > last.high) {
            movement = ThresholdMovement.INCREASE;
        } else if (balance === 0) {
            movement = ThresholdMovement.CRITICAL;
        } else {
            movement = ThresholdMovement.NONE;
        }
    }

    operatorStates[operator.address] = { low: newLow, high: newHigh };
    return [movement, balance, last];
}

export async function checkOperatorsBalanceRelativeToThreshold(messageStack: string[]) {
    console.log(jobNonceMsg(name, operatorBalanceThresholdsNonce, false));
    let jobMessages: string[] = [];

    const commitOperator = new Operator(OperatorType.COMMIT, COMMIT_OPERATOR_ADDRESS, null);
    let [movement, balance, lastThreshold] = await updateThreshold(commitOperator, messageStack);
    if (movement !== ThresholdMovement.NONE) {
        jobMessages.push(thresholdMovementMsg(commitOperator, movement, lastThreshold, balance));
    }
    messageStack.push(thresholdMovementMsg(commitOperator, movement, lastThreshold, balance));

    const blobsOperator = new Operator(OperatorType.BLOBS, BLOBS_OPERATOR_ADDRESS, null);
    [movement, balance, lastThreshold] = await updateThreshold(blobsOperator, messageStack);
    if (movement !== ThresholdMovement.NONE) {
        jobMessages.push(thresholdMovementMsg(blobsOperator, movement, lastThreshold, balance));
    }
    messageStack.push(thresholdMovementMsg(blobsOperator, movement, lastThreshold, balance));

    if (jobMessages.length !== 0) {
        const message = operatorThresholdMsg(jobMessages).join('\n');
        const slackResult = await sendSlackMessage(message);
        messageStack.push(slackResult ? "Logs sent" + slackSent : "Logs not sent" + slackError);
    }

    messageStack = flushMessageStack(messageStack);
    operatorBalanceThresholdsNonce++;
}
