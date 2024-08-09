# Safe CLI

## `bun safe`

```
Usage: safe [options] [command]

Options:
  -h, --help         display help for command

Commands:
  propose [options]  Propose a new Safe transaction
  sign [options]     Sign a Safe transaction
  execute [options]  Execute a Safe transaction
  help [command]     display help for command
```

## `bun safe propose`

```
Usage: safe propose [options]

Propose a new Safe transaction

Options:
  -t, --to <address>         The address of the recipient
  -c, --calldata <data>      The calldata for the transaction
  --safe-address <address>   The address of the Safe
  --rpc-url <url>            The RPC URL of the network
  --owner-private-key <key>  The private key of the signer (must be a Safe owner)
  -h, --help                 display help for command
```

## `bun safe sign`

```
Usage: safe sign [options]

Sign a Safe transaction

Options:
  --safe-tx-hash <hash>     The hash of the Safe transaction
  --safe-address <address>  The address of the Safe
  --rpc-url <url>           The RPC URL of the network
  --private-key <key>       The private key of the signer (must be a Safe owner)
  -h, --help                display help for command
```
## `bun safe execute`

```
Usage: safe execute [options]

Execute a Safe transaction

Options:
  --safe-tx-hash <hash>      The hash of the Safe transaction to execute
  --safe-address <address>   The address of the Safe
  --rpc-url <url>            The RPC URL of the network
  --owner-private-key <key>  The private key of the signer (must be a Safe owner)
  -h, --help                 display help for command
```
