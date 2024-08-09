import { CronJob } from 'cron';
import { ADVANCE_BLOCKCHAIN_CHECK_INTERVAL, DAILY_OPERATOR_BALANCE_CHECK_INTERVAL, OPERATOR_BALANCE_THRESHOLD_CHECK_INTERVAL } from './config';
import { checkAdvanceBlockchain } from './jobs/advance_blockchain';
import { checkOperatorsBalance } from './jobs/operator_balance';
import { checkOperatorsBalanceRelativeToThreshold } from './jobs/operator_balance_threshold';

async function main () {
    console.log("Starting health checker...");   

    new CronJob(DAILY_OPERATOR_BALANCE_CHECK_INTERVAL, () => {
        checkOperatorsBalance([]).catch(console.error);
    }).start();

    new CronJob(OPERATOR_BALANCE_THRESHOLD_CHECK_INTERVAL, () => {
        checkOperatorsBalanceRelativeToThreshold([]).catch(console.error);
    }).start();

    new CronJob(ADVANCE_BLOCKCHAIN_CHECK_INTERVAL, () => {
        checkAdvanceBlockchain([]).catch(console.error);
    }).start();

};

main().catch(console.error);
