import { IncomingWebhook } from "@slack/webhook";
import { SLACK_HOOK_URL } from './config';

export const slackSent = " \u2705";
export const slackError = " \u274C"

export const sendSlackMessage = async (message: string) => {
    const slack = new IncomingWebhook(SLACK_HOOK_URL);
    
    try {
        await slack.send(message);
        return true;
    } catch (error) {
        return false
    }
 }    
