# Safe Token Bridging Demo

## Overview

Following this demo, you will

1. Create a Vesting Wallet.
2. Transfer tokens from a Safe contract to the Vesting Wallet.
3. Wait for the Vesting Wallet to release the tokens.
4. Claim the tokens from the Vesting Wallet.
5. Bridge the tokens to ZKsync.

## Prerequisites

1. [`bun`](https://bun.sh/docs/installation)
2. [`foundry`](https://book.getfoundry.sh/getting-started/installation)

## Installing dependencies

```
make install
```

## Running the demo

Before running the demo you must create a `.env` file based on the `.env.example` file and then source it:

```
make env
```

### Create a Vesting Wallet

```
make create-vesting-wallet
```

> **NOTE:** After this, export an environment variable with the Vesting Wallet address with the name `VESTING_WALLET_ADDRESS` (this is a must for the next steps).

> *TODO*: we are working on a way to propose the Vesting Wallet creation to the Safe.

### Transfer tokens to the Vesting Wallet

To transfer tokens from a Safe contract to the Vesting Wallet we need to propose a transaction to the Safe contract, said transaction must reach the minimum needed signatures before it can be executed. You can do this by running:

```
make propose-token-transfer
```

The above will print the hash of the proposed transaction, this is needed for the other Safe owners to sign the transaction. You can either sign the tx using the Safe Wallet GUI or by running:

```
make sign-safe-tx SAFE_TX_HASH=<safe-tx-hash> SIGNER_PRIVATE_KEY=<signer-private-key>
```

Finally, you can also either execute the tx using the Safe Wallet GUI or by running:

```
make execute-safe-tx SAFE_TX_HASH=<safe-tx-hash> SIGNER_PRIVATE_KEY=<signer-private-key>
```

### Wait for the Vesting Wallet to release the tokens

The Vesting Wallet contract has a method to see if some token is releasable and what amount of it is. You can check this by running:

```
make available-tokens
```

### Claim the tokens from the Vesting Wallet

Once the tokens are available, you can claim them by running:

```
make claim-tokens
```

### Bridge the tokens to ZKsync

Go to our testnet bridge, connect your wallet and bridge the tokens.
