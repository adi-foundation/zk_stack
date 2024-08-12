import { Wallet, Provider, utils } from "zksync-ethers";
import { IERC20 } from "zksync-ethers/build/utils";
import * as ethers from "ethers";
import { env } from "process";
import { parseArgs } from "util";
import contractAbi from "./erc20_abi.json";


// HTTP RPC endpoints
const L1_RPC_ENDPOINT = env.L1_RPC_URL || "http://127.0.0.1:8545";
const L2_RPC_ENDPOINT = env.L2_RPC_URL || "http://127.0.0.1:3050";

const getERC20Balance = async (address: string, ERC20_L1: ethers.ethers.Contract, ERC20_DECIMALS_MUL: number, ERC20_SYMBOL: string) => {
    await ERC20_L1.balanceOf(address)
        .then((balance: number) => {
            console.log(`L1 ERC20 Balance: ${balance / ERC20_DECIMALS_MUL} ${ERC20_SYMBOL}`);
        })
        .catch(() => {
            console.error("Error fetching ERC20 balance from L1");
        });
}
const L1_RICH_PK = "0x850683b40d4a740aa6e745f889a6fdc8327be76e122f5aba645a5b02d0248db8";
async function main() {
    // Initialize the wallet.
    const l1provider = new ethers.providers.JsonRpcProvider(L1_RPC_ENDPOINT)
    const l2provider = new Provider(L2_RPC_ENDPOINT);

    console.log(`L1 Endpoint: ${L1_RPC_ENDPOINT}`);
    console.log(`L2 Endpoint: ${L2_RPC_ENDPOINT}`);


    const walletEthers = new ethers.Wallet(L1_RICH_PK, l1provider);

    const ERC20_L1 = new ethers.Contract(await l2provider.getBaseTokenContractAddress(), contractAbi, walletEthers);
    const ERC20_SYMBOL: string = await ERC20_L1.symbol();
    const ERC20_DECIMALS_MUL = Math.pow(10, Number(await ERC20_L1.decimals()));

    console.log("#####################################################\n");

    await getERC20Balance("0xf2248620e8E98628b4F4a82a3f6dfe4F5993ceBa", ERC20_L1, ERC20_DECIMALS_MUL, ERC20_SYMBOL);
    await getERC20Balance(walletEthers.address, ERC20_L1, ERC20_DECIMALS_MUL, ERC20_SYMBOL);
}

main()
    .then()
    .catch((error) => {
        console.error(error);
        env.exitCode = "1";
    });
