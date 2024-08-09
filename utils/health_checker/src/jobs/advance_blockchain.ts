
import { Provider } from "zksync-ethers";
import { advanceBlockchainMsg, jobNonceMsg, MsgCode } from "../../models/message";
import { Operator, OperatorType } from "../../models/operator";
import { L2_RPC_ENDPOINT, SENDER_ADDRESS, SENDER_PK } from "../config";
import * as rpc from "../rpc";
import { sendSlackMessage, slackError, slackSent } from "../slack";
import { flushMessageStack } from "../utils";

let name = "Advance Blockchain"
let advanceBlockchainNonce = 1;
let prevBlock = 0;

const l2_provider = new Provider(L2_RPC_ENDPOINT);

async function checkNewBlocks(messageStack: string[]) {
    // First time executing job. Set the current last block 
    if (advanceBlockchainNonce === 1) {
        prevBlock = await l2_provider.getBlockNumber();
    }

    let currentBlock = await l2_provider.getBlockNumber();
    const newBlocks = currentBlock - prevBlock; 
    messageStack.push(`${MsgCode.INFO} Chain has advanced ${newBlocks} block(s) since last time`);
    prevBlock = currentBlock;
}

export async function checkAdvanceBlockchain(messageStack: string[]) {
    const start = new Date().getTime();
    console.log(jobNonceMsg(name, advanceBlockchainNonce, false));

    const _newBlocks = await checkNewBlocks(messageStack);
    const senderOperator = new Operator(OperatorType.TX_SENDER, SENDER_ADDRESS, SENDER_PK!);
    
    // Create a tx and check blockchain advanced as expected    
    const [success, batchNumber] = await rpc.deposit(senderOperator, messageStack);
    if (success) {
        const commitSuccess = await rpc.waitForCommitHash(batchNumber, 0, messageStack);
        const proveSuccess = await rpc.waitForProveHash(batchNumber, 0, messageStack);
        const executeSuccess = await rpc.waitForExecuteHash(batchNumber, 0, messageStack);
        
        if (commitSuccess && proveSuccess && executeSuccess) {
            const elapsed = (new Date().getTime() - start)/1000;
            const message = advanceBlockchainMsg(batchNumber, elapsed).join('\n');
            
            messageStack.push(message);
            await sendSlackMessage(message)
            ? messageStack.push("Logs sent" + slackSent)
            : messageStack.push("Logs not sent" + slackError)
        }
    } else {
        const errorMessage = `${MsgCode.ERROR} Error producing a batch and advancing the chain`;
        await sendSlackMessage(errorMessage)
        ? messageStack.push(errorMessage + slackSent)
        : messageStack.push(errorMessage + slackError)
    }
    // Print and increase job nonce
    messageStack = flushMessageStack(messageStack);
    advanceBlockchainNonce++;
};
