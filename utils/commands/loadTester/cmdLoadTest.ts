import { Wallet, Provider } from "zksync-ethers";
import * as ethers from "ethers";

import { env } from "process";
import contractAbi from "./helpers/erc20_abi.json";
import { helpers } from "./helpers";

// HTTP RPC endpoints
const L1_RPC_ENDPOINT = "http://127.0.0.1:8545";
const L2_RPC_ENDPOINT = "http://127.0.0.1:3050";

const AMOUNT_TO_BRIDGE = "100";
const AMOUNT_OF_ETH = "0.05";
const AMOUNT_OF_WALLETS = 5;

const L1_RICH_PK = "0x850683b40d4a740aa6e745f889a6fdc8327be76e122f5aba645a5b02d0248db8";

export async function loadTest(l1url: string, l2url: string, pk: string, numberOfWallets: number, amount: string, shots: number, deposits: boolean) {
    let actualShots = 1;
    if (shots === 0) {
        actualShots = 0;
    }
    else if (shots) {
        actualShots = shots
    }
    const l1Deposits = deposits ? true : false;

    const L1_RICH = pk || L1_RICH_PK;

    // Initialize the rich wallet, ERC20 contract and providers
    const l1Rpc = l1url || L1_RPC_ENDPOINT;
    const l2Rpc = l2url || L2_RPC_ENDPOINT;
    const l1Provider = new ethers.providers.JsonRpcProvider(l1Rpc);
    const l2Provider = new Provider(l2Rpc);
    const zkWallet = new Wallet(L1_RICH, l2Provider, l1Provider);

    const ethWallet = new ethers.Wallet(L1_RICH, l1Provider);
    const ERC20_L1 = new ethers.Contract(
        await l2Provider.getBaseTokenContractAddress(),
        contractAbi,
        ethWallet
    );
    const ERC20_SYMBOL: string = await ERC20_L1.symbol();
    const ERC20_DECIMALS_MUL = Math.pow(10, Number(await ERC20_L1.decimals()));

    // Initialize the rich wallet.
    const amountOfWallets = numberOfWallets || AMOUNT_OF_WALLETS;
    let wallets: Wallet[] = new Array<Wallet>();
    for (let index = 0; index < amountOfWallets; index++) {
        const pk = Wallet.createRandom().privateKey;
        const w = new Wallet(pk, l2Provider, l1Provider);
        wallets.push(w);
    }

    const amountToBridge = Number(amount || AMOUNT_TO_BRIDGE);
    const amountForEach = amountToBridge / wallets.length;

    console.log("#####################################################\n");
    wallets.forEach((w, i) => {
        console.log(
            `Wallet(${i.toString().padStart(2, "0")}) addr: ${w.address} || pk: ${w.privateKey}`
        );
    });


    let retries = 0;
    while (true) {
        console.log("\n#####################################################\n");
        console.log(`Address: ${ethWallet.address}`);
        console.log(`[L1] Endpoint: ${l1Rpc}`);
        console.log(`L1 Balance: ${ethers.utils.formatEther(await ethWallet.getBalance())}`);
        console.log(`[L2] Endpoint: ${l2Rpc}`);
        console.log(`L2 Balance: ${ethers.utils.formatEther(await zkWallet.getBalance())}`);
        console.log("\n#####################################################\n");

        const erc20Balance: number = await helpers.l1.getERC20Balance(
            ethWallet.address,
            ERC20_L1,
            ERC20_DECIMALS_MUL,
            ERC20_SYMBOL
        );

        if (erc20Balance <= amountToBridge) {
            const response = await ERC20_L1.mint(
                ethWallet.address,
                BigInt(amountToBridge * ERC20_DECIMALS_MUL)
            );
            const receipt = await response.wait();
            console.log(
                `${amountToBridge} Minted ${ERC20_SYMBOL}, txHash: ${receipt.transactionHash}`
            );
            await helpers.l1.getERC20Balance(
                ethWallet.address,
                ERC20_L1,
                ERC20_DECIMALS_MUL,
                ERC20_SYMBOL
            );
        }

        // Not ideal, gas calculations has to be performed
        const amountForEachToDeposit = amountForEach * 0.9;
        const baseTokenAddress = await zkWallet.provider.getBaseTokenContractAddress();

        switch (l1Deposits) {
            case true:
                let consumedL1Gas = await ethWallet.provider.getBalance(ethWallet.address);

                console.log("=====================================================");

                console.log(`[L1 -> L1]: Send ETH`);
                const amountOfEth = ethers.utils.parseEther(AMOUNT_OF_ETH).div(wallets.length);
                await helpers.l1.sendMultipleL1ETHTransfers(ethWallet, wallets, ethers.utils.formatEther(amountOfEth));

                console.log("=====================================================");

                console.log("[L1 -> L1]: Send ERC20");
                await helpers.l1.sendMultipleL1ERC20Transfers(
                    ethWallet,
                    wallets,
                    amountForEach,
                    ERC20_L1
                );

                console.log("=====================================================");

                consumedL1Gas = consumedL1Gas.add(amountOfEth).sub(
                    await ethWallet.provider.getBalance(ethWallet.address)
                );

                console.log(`Consumed L1 Gas: ${ethers.utils.formatEther(consumedL1Gas)}`);

                console.log("=====================================================");

                console.log("[L1->L2]: Deposit BaseToken");
                // Deposit from one of the random wallet to the same random wallet, it's not blocking.
                // It will do the deposits in parallel.
                // This operation requires ERC20 and ETH in L1 for each wallet.
                await helpers.l2.sendMultipleL2BaseTokenDeposits(zkWallet, wallets, amountForEachToDeposit);
                await helpers.l2.l1ToL2ERC20Deposit(
                    zkWallet,
                    zkWallet.address,
                    baseTokenAddress,
                    String(amount)
                );
                console.log("=====================================================");
                break;
            default:
                console.log("=====================================================");
                // Deposit from rich wallet to all the random wallets, it;s blocking.
                // It will do one deposit at a time.
                console.log("[L1->L2]: Deposit BaseToken");
                for (const w of wallets) {
                    await helpers.l2.l1ToL2ERC20Deposit(
                        zkWallet,
                        w.address,
                        baseTokenAddress,
                        String(amountForEachToDeposit)
                    );
                }
                await helpers.l2.l1ToL2ERC20Deposit(
                    zkWallet,
                    zkWallet.address,
                    baseTokenAddress,
                    String(amount)
                );
                console.log("=====================================================");
                break;
        }

        // Not ideal, gas calculations has to be performed
        const amountForEachToTransfer = amountForEachToDeposit * 0.9;
        console.log("[L2->L2]: Transfer BaseToken");
        await helpers.l2.sendMultipleL2Transfers(zkWallet, wallets, amountForEachToTransfer);

        console.log("=====================================================");
        retries++;
        if (retries == actualShots) {
            console.log(`The LoadTest has finished after ${retries} retry/ies`);
            break;
        }
    }

}
