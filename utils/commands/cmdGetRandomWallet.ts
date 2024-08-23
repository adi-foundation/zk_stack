import * as ethers from "ethers";

export async function getRandomWallet(privateKey: string) {
    if (privateKey) {
        console.log(`PrivKey: ${privateKey}`);
        console.log(`Address: ${ethers.utils.computeAddress(privateKey)}`);
    } else {
        const wallet = ethers.Wallet.createRandom();
        console.log(`PrivKey: ${wallet.privateKey}`);
        console.log(`Address: ${wallet.address}`);
    }
}
