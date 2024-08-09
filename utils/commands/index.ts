import { getBalance } from "./cmdGetBalance";
import { sendBalance } from "./cmdSendBalance";
import { depositBalance } from "./cmdDeposit";
import { fixNonce } from "./cmdFixNonce";
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
    utils: {
        getRandomWallet
    }
}
