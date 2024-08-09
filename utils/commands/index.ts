import { getBalance } from "./cmdGetBalance";
import { sendBalance } from "./cmdSendBalance";
import { depositBalance } from "./cmdDeposit";
import { fixNonce } from "./cmdFixNonce";

export const cmd = {
    balance: {
        getBalance,
        sendBalance,
        depositBalance
    },
    maintenance: {
        fixNonce
    }
}
