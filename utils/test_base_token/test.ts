import { Wallet, Provider, utils } from "zksync-ethers";
import * as ethers from "ethers";
import contractAbi from "./erc20_basic_abi.json"

// HTTP RPC endpoints
const L1_RPC_ENDPOINT = "http://127.0.0.1:8545";
const L2_RPC_ENDPOINT = "http://127.0.0.1:3050";

const L1_RICH_PK = "0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110";

const getERC20Balance = async (address: string, ERC20_L1: ethers.ethers.Contract, ERC20_DECIMALS_MUL: number, ERC20_SYMBOL: string) => {
    await ERC20_L1.balanceOf(address)
        .then((balance: number) => {
            console.log(`L1 ERC20 Balance: ${balance / ERC20_DECIMALS_MUL} ${ERC20_SYMBOL}`);
        })
        .catch(() => {
            console.error("Error fetching ERC20 balance from L1");
        });
}

const withdraw = async (zkwallet: Wallet, token: string, amount: string, ERC20_L1: ethers.ethers.Contract, ERC20_DECIMALS_MUL: number, ERC20_SYMBOL: string) => {
    const tx_wd = await zkwallet.withdraw({
        token,
        amount: ethers.utils.parseEther(amount),
    })
    const receipt_wd = await tx_wd.wait();
    console.log(`Is Withdrawal finalized: ${await zkwallet.isWithdrawalFinalized(receipt_wd.transactionHash)}`);
    console.log(`Withdrawal hash: ${receipt_wd.transactionHash}`);
    await zkwallet.finalizeWithdrawalParams(
        receipt_wd.transactionHash
    );

    console.log("\n#####################################################\n")
    console.log(`L1 balance after withdraw: ${ethers.utils.formatEther(await zkwallet.getBalanceL1())} ${ethers.constants.EtherSymbol}`);
    await getERC20Balance(zkwallet.address, ERC20_L1, ERC20_DECIMALS_MUL, ERC20_SYMBOL);
    console.log(`L2 balance after withdraw: ${ethers.utils.formatEther(await zkwallet.getBalance())}`)
    console.log("\n#####################################################\n")
}

const deposit = async (zkwallet: Wallet, token: string, amount: string) => {
    const tx = await zkwallet.deposit({
        token,
        amount: ethers.utils.parseEther(amount),
        approveERC20: true,
        approveBaseERC20: true,
    });
    const receipt = await tx.wait();
    console.log(`Tx: ${receipt.transactionHash}`);

    console.log("\n#####################################################\n")
    console.log(`L2 balance after deposit: ${ethers.utils.formatEther(await zkwallet.getBalance())}`)
    console.log("\n#####################################################\n")
}

async function main() {
    // Initialize the wallet.
    const l1provider = new ethers.providers.JsonRpcProvider(L1_RPC_ENDPOINT)
    const l2provider = new Provider(L2_RPC_ENDPOINT);
    const wallet1 = new Wallet(L1_RICH_PK, l2provider, l1provider);

    const walletEthers = new ethers.Wallet(L1_RICH_PK, l1provider);

    const ERC20_L1 = new ethers.Contract(await l2provider.getBaseTokenContractAddress(), contractAbi, walletEthers);
    const ERC20_SYMBOL: string = await ERC20_L1.symbol();
    const ERC20_DECIMALS_MUL = Math.pow(10, Number(await ERC20_L1.decimals()));

    console.log("#####################################################\n");

    // Used locally
    await ERC20_L1.mint(await walletEthers.getAddress(), BigInt(1000 * ERC20_DECIMALS_MUL));
    await getERC20Balance(wallet1.address, ERC20_L1, ERC20_DECIMALS_MUL, ERC20_SYMBOL);
    console.log("\n#####################################################\n");

    console.log(`L2 base_token_address : ${await l2provider.getBaseTokenContractAddress()}`);
    console.log(`isEthBased: ${await l2provider.isEthBasedChain()}`);

    console.log(`Send some ERC20`);
    await deposit(wallet1, await l2provider.getBaseTokenContractAddress(), "1");

    console.log("\n#####################################################\n")

    console.log(`Send some ETH`);
    await deposit(wallet1, utils.ETH_ADDRESS, "1");

    console.log("\n#####################################################\n")
    console.log(`L1 balance after deposit: ${ethers.utils.formatEther(await wallet1.getBalanceL1())} ${ethers.constants.EtherSymbol}`);
    await getERC20Balance(wallet1.address, ERC20_L1, ERC20_DECIMALS_MUL, ERC20_SYMBOL);
    console.log("\n#####################################################\n")

    //await withdraw(wallet1, await l2provider.getBaseTokenContractAddress(), "1", ERC20_L1, ERC20_DECIMALS_MUL, ERC20_SYMBOL);

    const balances = await l2provider.getAllAccountBalances(wallet1.address)
    console.log(`All balances: ${utils.toJSON(balances)}`);
    for (let [address, balance] of Object.entries(balances)) {
        const bal = parseInt(balance._hex, 16) / 1e18;
        if (address == `0x0000000000000000000000000000000000000000`) {
            console.log(`BaseToken: ${bal}`);
        } else {
            console.log(`${address}: ${bal}`);
        }
    }
}

main()
    .then()
    .catch((error) => {
        console.error(error);
        process.env.exitCode = "1";
    });
