# Execute the zk_inception commands
echo "Creating ecosystem with zk_inception..."
zk_inception ecosystem create \
    --ecosystem-name ecosystem \
    --l1-network sepolia \
    --link-to-code /usr/src/app/zksync-era \
    --chain-name sepolia-no-prover-rollup-base-token \
    --prover-mode no-proofs \
    --wallet-creation in-file \
    --wallet-path /root/custom-wallets.yaml \
    --l1-batch-commit-data-generator-mode rollup \
    --base-token-address 0xd0580192E98eA6CEB9c7b6191Ed2E27560911697 \
    --base-token-price-nominator 1 \
    --base-token-price-denominator 10 \
    --start-containers false \
    --verbose \
    --chain-id 271 || { echo "Failed to create ecosystem"; exit 1; }
    


# Move to the ecosystem directory
cd ecosystem || { echo "Failed to change directory to ecosystem"; exit 1; }

# Run zk_inception containers
echo "Starting containers with zk_inception..."
zk_inception ecosystem init \
    --deploy-paymaster false \
    --deploy-erc20 false \
    --deploy-ecosystem true \
    --verbose \
    --l1-rpc-url "https://rpc.sepolia.org" || { echo "Failed to init the ecosystem"; exit 1; }
