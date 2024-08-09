import { jobNonceMsg, operatorBalanceMsg } from "../../models/message";
import { Operator, OperatorType } from "../../models/operator";
import { BLOBS_OPERATOR_ADDRESS, COMMIT_OPERATOR_ADDRESS } from "../config";
import { sendSlackMessage, slackError, slackSent } from "../slack";
import { flushMessageStack } from "../utils";

let operatorBalanceNonce = 1;
let name = "Daily Operator Balance Check"

export async function checkOperatorsBalance(messageStack: string[]) {
    console.log(jobNonceMsg(name, operatorBalanceNonce, false));

    const commitOperator = new Operator(OperatorType.COMMIT, COMMIT_OPERATOR_ADDRESS, null);
    const blobsOperator = new Operator(OperatorType.BLOBS, BLOBS_OPERATOR_ADDRESS, null);
    const operators = [commitOperator, blobsOperator];
    const message = (await operatorBalanceMsg(operators)).join('\n');
    
    messageStack.push(message);
    await sendSlackMessage(message)
    ? messageStack.push("Logs sent" + slackSent)
    : messageStack.push("Logs sent" + slackError);    

    messageStack = flushMessageStack(messageStack);
    operatorBalanceNonce++;
};
