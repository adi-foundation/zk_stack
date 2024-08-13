import { getERC20Balance, sendMultipleL1ERC20Transfers, sendMultipleL1ETHTransfers, l1ERC20Transfer } from "./L1-utils";
import { l1ToL2ERC20Deposit, sendMultipleL2BaseTokenDeposits, sendMultipleL2Transfers } from "./L2-utils";

export const helpers = {
    l1: {
        getERC20Balance,
        sendMultipleL1ERC20Transfers,
        sendMultipleL1ETHTransfers,
        l1ERC20Transfer
    },
    l2: {
        l1ToL2ERC20Deposit,
        sendMultipleL2BaseTokenDeposits,
        sendMultipleL2Transfers
    }
}
