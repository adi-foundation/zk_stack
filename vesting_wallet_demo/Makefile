.PHONY: propose-token-transfer

install:
	bun i

env:
	source .env

propose-vesting-wallet-deployment:
	echo "TODO"

create-vesting-wallet:
	forge create contracts/vesting.sol:Vesting --constructor-args ${BENEFICIARY_ADDRESS} $(date +%s) 0 --private-key ${SAFE_OWNER_PRIVATE_KEY} --rpc-url ${SEPOLIA_URL}

propose-token-transfer:
	bun safe propose --to ${TOKEN_ADDRESS} --calldata $(cast calldata "transfer(address,uint256)(bool)" ${VESTING_WALLET_ADDRESS} 100000000000000000000) --safe-address ${SAFE_ADDRESS} --rpc-url ${SEPOLIA_URL} --owner-private-key $SAFE_OWNER_PRIVATE_KEY

sign-safe-tx:
	bun safe sign --safe-address ${SAFE_ADDRESS} --safe-tx-hash $SAFE_TX_HASH --rpc-url ${SEPOLIA_URL} --owner-private-key ${SIGNER_PRIVATE_KEY}

execute-safe-tx:
	bun safe execute --safe-address ${SAFE_ADDRESS} --safe-tx-hash $SAFE_TX_HASH --rpc-url ${SEPOLIA_URL} --owner-private-key ${SIGNER_PRIVATE_KEY}

available-tokens:
	cast call ${VESTING_WALLET_ADDRESS} "releasable(address)(uint256)" ${TOKEN_ADDRESS} --rpc-url ${SEPOLIA_URL}

claim-tokens:
	cast send ${VESTING_WALLET_ADDRESS} "release(address)" ${TOKEN_ADDRESS} --rpc-url ${SEPOLIA_URL} --private-key ${BENEFICIARY_PRIVATE_KEY}
