#!/bin/bash

CONFIG_FILE=${CONFIG_FILE:-./config.json}
if [ ! -f $CONFIG_FILE ]; then
	echo "Error: The config file ($CONFIG_FILE) doesn't exist"
	exit 1
fi

jq --version >/dev/null 2>&1 && (echo "" | sponge) >/dev/null 2>&1
if [ $? != 0 ]; then
	echo "Error: Please make sure you have jq and sponge installed and in your PATH"
	exit 2
fi

ZK_ENV=$(jq -r .network.env_name $CONFIG_FILE)

mkdir -p custom_configs

get_param () {
	jq $1 $CONFIG_FILE
}

lower () {
	tr '[:upper:]' '[:lower:]'
}

# Portal
jq \
	".[0].network.id = $(get_param .network.l2.chain_id) | \
	 .[0].network.key = $(get_param .network.l2.name | lower) | \
	 .[0].network.name = $(get_param .network.l2.name) | \
	 .[0].network.rpcUrl = $(get_param .network.l2.rpc_url) | \
	 .[0].network.blockExplorerUrl = $(get_param .explorer.web_url) | \
	 .[0].network.blockExplorerApi = $(get_param .explorer.api_url) | \
	 .[0].network.l1Network.id = $(get_param .network.l1.chain_id) | \
	 .[0].network.l1Network.name = $(get_param .network.l1.name) | \
	 .[0].network.l1Network.rpcUrls.default.http = [$(get_param .network.l1.rpc_url)] | \
	 .[0].network.l1Network.rpcUrls.public.http = [$(get_param .network.l1.rpc_url)] | \
	 .[0].tokens += $(get_param .portal.extra_tokens)" \
	configs/portal.config.json > custom_configs/portal.json

sed "s/^WALLET_CONNECT_PROJECT_ID=.*$/WALLET_CONNECT_PROJECT_ID=$(get_param .portal.wallet_connect_apikey)/" configs/portal.env | \
sed "s/ANKR_TOKEN=.*$/ANKR_TOKEN=$(get_param .portal.ankr_token)/" > custom_configs/portal.env

# Explorer
jq \
	".networks[0].apiUrl = $(get_param .explorer.api_url) | \
	 .networks[0].bridgeUrl = $(get_param .portal.web_url) | \
	 .networks[0].hostnames = $(get_param .explorer.hostnames) | \
	 .networks[0].l2ChainId = $(get_param .network.l2.chain_id) | \
	 .networks[0].l2NetworkName = $(get_param .network.l2.name) | \
	 .networks[0].name = $(get_param .network.l2.name | lower) | \
	 .networks[0].rpcUrl = $(get_param .network.l2.rpc_url) | \
	 .networks[0].baseTokenAddress = $(get_param .network.base_token.l1_address)" \
	configs/explorer.config.json > custom_configs/explorer.json

# ZK env
proof_mode='"SkipEveryProof"'
if [[ $(get_param .network.prover) == true ]]; then
	proof_mode='"OnlyRealProofs"'
fi

sed "s;l2-inits/custom.init.env;l2-inits/$ZK_ENV.init.env;" configs/network.toml | \
sed "s/^network.=.*$/network = $(get_param .network.l1.name | lower)/" | \
sed "s/^fee_account_addr.=.*$/fee_account_addr = $(get_param .network.fee_account_addr)/" | \
sed "s;^web3_url.=.*$;web3_url = $(get_param .network.l1.rpc_url);" | \
sed "s/^operator_private_key.=.*$/operator_private_key = $(get_param .network.operator_private_key)/" | \
sed "s/^operator_commit_eth_addr.=.*$/operator_commit_eth_addr = $(get_param .network.operator_commit_eth_addr)/" | \
sed "s/^operator_blobs_private_key.=.*$/operator_blobs_private_key = $(get_param .network.operator_blobs_private_key)/" | \
sed "s/^operator_blobs_eth_addr.=.*$/operator_blobs_eth_addr = $(get_param .network.operator_blobs_eth_addr)/" | \
sed "s/^proof_sending_mode.=.*$/proof_sending_mode = ${proof_mode}/" | \
sed "s/^fee_account_private_key.=.*$/fee_account_private_key = $(get_param .network.fee_account_private_key)/" | \
sed "s/^BASE_TOKEN_ADDR.=.*$/BASE_TOKEN_ADDR = $(get_param .network.base_token.l1_address)/" > custom_configs/$ZK_ENV.toml

# Makefile
sed "s/^ZKSYNC_DEPLOYER_PRIVATE_KEY=.*$/ZKSYNC_DEPLOYER_PRIVATE_KEY=$(get_param .network.deployer_private_key)/" Makefile | \
sed "s/^ZKSYNC_GOVERNANCE_PRIVATE_KEY=.*$/ZKSYNC_GOVERNANCE_PRIVATE_KEY=$(get_param .network.deployer_private_key)/" | \
sed "s/^ZKSYNC_GOVERNOR_PRIVATE_KEY=.*$/ZKSYNC_GOVERNOR_PRIVATE_KEY=$(get_param .network.deployer_private_key)/" | \
sed "s/^ZKSYNC_BASE_TOKEN_NAME=.*$/ZKSYNC_BASE_TOKEN_NAME=$(get_param .network.base_token.symbol)/" | \
sed "s/^ZKSYNC_ENV=.*$/ZKSYNC_ENV=$ZK_ENV/" | sponge Makefile
