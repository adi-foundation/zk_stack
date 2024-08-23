import { getBalance } from "./cmdGetBalance";
import { sendBalance } from "./cmdSendBalance";
import { depositBalance } from "./cmdDeposit";
import { fixNonce } from "./cmdFixNonce";
import { loadTest } from "./loadTester/cmdLoadTest";
import { getRandomWallet } from "./cmdGetRandomWallet";

export const cmd = {
    balance: {
        getBalance,
        sendBalance,
        depositBalance
    },
    maintenance: {
        fixNonce
    },
    test: {
        loadTest
    },
    utils: {
        getRandomWallet
    }
}
