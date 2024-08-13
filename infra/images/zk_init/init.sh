#!/bin/bash

CONFIGMAP_NAME=${CONFIGMAP_NAME:-test-server-envs}

# If ConfigMap already exists, quit
if [[ "$(kubectl get configmaps -oNAME | grep ^configmap/$CONFIGMAP_NAME$)" != "" ]]
then
	echo "The ConfigMap $CONFIGMAP_NAME already exist. Delete it before running this job or change the CONFIGMAP_NAME env var"
	exit 1
fi

export ZKSYNC_ENV=${ZKSYNC_ENV:-custom}
export ZKSYNC_HOME=/zksync
export PATH=${ZKSYNC_HOME}/bin:$PATH

cp /configs/${ZKSYNC_ENV}.toml ${ZKSYNC_HOME}/etc/env/configs/${ZKSYNC_ENV}.toml

export CUSTOM_BASE_TOKEN=$(grep '^BASE_TOKEN_ADDR[ ]*=' ${ZKSYNC_HOME}/etc/env/configs/${ZKSYNC_ENV}.toml | head -n1 | sed -E 's/BASE_TOKEN_ADDR[ ]*=[ "]*0x([a-fA-F0-9]*)"*/0x\1/')
if [[ "$CUSTOM_BASE_TOKEN" == "0x0000000000000000000000000000000000000001" ]]
then
	export CUSTOM_BASE_TOKEN=""
else
	if [[ "$BASE_TOKEN_SYMBOL" == "" ]]; then
		echo "A base token address is provided but BASE_TOKEN_SYMBOL is not set"
		exit 1
	fi
	BASE_TOKEN_DECIMALS=${BASE_TOKEN_DECIMALS:-18}
	BASE_TOKEN_NAME=${BASE_TOKEN_NAME:-$BASE_TOKEN_SYMBOL}
	L1_NAME=$(grep '^network[ ]*=' ${ZKSYNC_HOME}/etc/env/configs/${ZKSYNC_ENV}.toml | sed -E 's/^network[ ]*=[ "]*([^"]*)"*/\1/' || echo "localhost")

	ls ${ZKSYNC_HOME}/etc/tokens/${L1_NAME}.json >/dev/null 2>&1 || echo "[]" > ${ZKSYNC_HOME}/etc/tokens/${L1_NAME}.json
	jq '. |= . + [{
		"name": "'$BASE_TOKEN_NAME'",
		"symbol": "'$BASE_TOKEN_SYMBOL'",
		"decimals": '$BASE_TOKEN_DECIMALS',
		"address": "'$CUSTOM_BASE_TOKEN'"
	},{
		"name": "WETH",
		"symbol": "WETH",
		"decimals": 18,
		"address": "0xeBcDEd21470fc7Bdf30D78e1263399cdfA743c9c"
	}]' ${ZKSYNC_HOME}/etc/tokens/${L1_NAME}.json > tokens_new.json
	mv tokens_new.json ${ZKSYNC_HOME}/etc/tokens/${L1_NAME}.json
fi

echo "CUSTOM BASE TOKEN: $CUSTOM_BASE_TOKEN"

zk
zk env ${ZKSYNC_ENV}

if [[ "$BASE_TOKEN_SYMBOL" == "" || "$CUSTOM_BASE_TOKEN" == "0x0000000000000000000000000000000000000001" ]]
then
	zk init --skip-env-setup
else
	zk init --base-token-name ${BASE_TOKEN_SYMBOL} --skip-env-setup --skip-submodules-checkout --skip-test-token-deployment
fi

zk env ${ZKSYNC_ENV}

sed -i -E 's/API_WEB3_JSON_RPC_ACCOUNT_PKS="([a-fA-F0-9x,]*)"/API_WEB3_JSON_RPC_ACCOUNT_PKS=\1/' ${ZKSYNC_HOME}/etc/env/target/$ZKSYNC_ENV.env
sed -i -E 's/ETH_SENDER_SENDER_AGGREGATED_PROOF_SIZES="(.*)"/ETH_SENDER_SENDER_AGGREGATED_PROOF_SIZES=\1/' ${ZKSYNC_HOME}/etc/env/target/$ZKSYNC_ENV.env

kubectl create configmap $CONFIGMAP_NAME --from-env-file=${ZKSYNC_HOME}/etc/env/target/$ZKSYNC_ENV.env

echo "Chain successfully initialized"
