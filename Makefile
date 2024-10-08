.PHONY: deps down clean prune download-server download-explorer download-portal download-prover setup-all setup-all-no-prover setup-server setup-explorer setup-portal setup-prover run-server run-explorer run-portal run-prover-gateway run-prover-witness-generator run-prover-witness-vector-gen run-prover-prover run-prover-compressor run-prover-all up-no-prover up server explorer portal prover-gateway prover-witness-generator prover-witness-vector-gen prover-prover prover-compressor prover-all

# Homes
ZKSYNC_SERVER_HOME=$(shell pwd)/zksync-era-server
ZKSYNC_PROVER_HOME=$(shell pwd)/zksync-era-prover
ZKSYNC_EXPLORER_HOME=$(shell pwd)/explorer
ZKSYNC_PORTAL_HOME=$(shell pwd)/portal
BELLMAN_CUDA_HOME=$(shell pwd)/bellman-cuda
# Repos
SERVER_REPO=https://github.com/matter-labs/zksync-era.git
PROVER_REPO=https://github.com/matter-labs/zksync-era.git
EXPLORER_REPO=https://github.com/matter-labs/block-explorer.git
PORTAL_REPO=https://github.com/matter-labs/dapp-portal.git
BELLMAN_CUDA_REPO=https://github.com/matter-labs/era-bellman-cuda.git
# Commits
SERVER_COMMIT=core-v24.7.0
PROVER_COMMIT=prover-v14.5.0
EXPLORER_COMMIT=main
PORTAL_COMMIT=fd29357b621b0413a0e778cd6c07236643c2a607
BELLMAN_CUDA_COMMIT=main
# Private keys
ZKSYNC_DEPLOYER_PRIVATE_KEY=
ZKSYNC_GOVERNANCE_PRIVATE_KEY=
ZKSYNC_GOVERNOR_PRIVATE_KEY=
# Envs
ZKSYNC_ENV=


# General

deps:
	sudo apt update && sudo apt install -y moreutils wget curl tmux jq pkg-config clang cmake
	# yq
	sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq
	sudo chmod +x /usr/bin/yq
	# Node.js and yarn
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	. "$(NVM_DIR)/nvm.sh" && nvm install 20
	corepack enable
	echo 'Y' | yarn --version
	# Rust
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
	cargo-binstall -y sqlx-cli --version 0.7.3

down:
	tmux kill-server || exit 0
	rm -rf /tmp/tmux*

clean:
	ZKSYNC_HOME=${ZKSYNC_SERVER_HOME} zk clean --all
	ZKSYNC_HOME=${ZKSYNC_PROVER_HOME} zk clean --all
	docker rm -f $(shell docker ps -qa) 2>/dev/null || exit 0

prune: down
	rm -rf ${ZKSYNC_SERVER_HOME} ${ZKSYNC_PROVER_HOME} ${ZKSYNC_PORTAL_HOME} ${ZKSYNC_EXPLORER_HOME}
	docker rm -f $(shell docker ps -qa) 2>/dev/null || exit 0

# Download

download-server: deps
	git -C ${ZKSYNC_SERVER_HOME} pull origin ${SERVER_COMMIT}:${SERVER_COMMIT} --ff-only 2>/dev/null || git clone ${SERVER_REPO} ${ZKSYNC_SERVER_HOME}
	git -C ${ZKSYNC_SERVER_HOME} checkout ${SERVER_COMMIT}
	cp diffs/observability.diff ${ZKSYNC_SERVER_HOME}
	cp diffs/era-server/contract-verifier.diff ${ZKSYNC_SERVER_HOME}
	cp custom_configs/${ZKSYNC_ENV}.toml ${ZKSYNC_SERVER_HOME}/etc/env/configs/${ZKSYNC_ENV}.toml
	git -C ${ZKSYNC_SERVER_HOME} apply observability.diff || exit 0
	git -C ${ZKSYNC_SERVER_HOME} apply contract-verifier.diff || exit 0
	@echo "Downloading some compiler versions for contract verifier"
	mkdir -p ${ZKSYNC_SERVER_HOME}/etc/zksolc-bin/v1.5.0
	mkdir -p ${ZKSYNC_SERVER_HOME}/etc/solc-bin/0.8.26
	mkdir -p ${ZKSYNC_SERVER_HOME}/etc/zkvyper-bin/v1.5.0
	mkdir -p ${ZKSYNC_SERVER_HOME}/etc/vyper-bin/v0.4.0
	curl -L -o ${ZKSYNC_SERVER_HOME}/etc/zksolc-bin/v1.5.0/zksolc https://github.com/matter-labs/zksolc-bin/releases/download/v1.5.0/zksolc-linux-amd64-musl-v1.5.0
	chmod +x ${ZKSYNC_SERVER_HOME}/etc/zksolc-bin/v1.5.0/zksolc
	curl -L -o ${ZKSYNC_SERVER_HOME}/etc/solc-bin/0.8.26/solc https://github.com/ethereum/solidity/releases/download/v0.8.26/solc-static-linux
	chmod +x ${ZKSYNC_SERVER_HOME}/etc/solc-bin/0.8.26/solc
	curl -L -o ${ZKSYNC_SERVER_HOME}/etc/zkvyper-bin/v1.5.0/zkvyper https://github.com/matter-labs/zkvyper-bin/releases/download/v1.5.0/zkvyper-linux-amd64-musl-v1.5.0
	chmod +x ${ZKSYNC_SERVER_HOME}/etc/zkvyper-bin/v1.5.0/zkvyper
	curl -L -o ${ZKSYNC_SERVER_HOME}/etc/vyper-bin/v0.4.0/vyper https://github.com/vyperlang/vyper/releases/download/v0.4.0/vyper.0.4.0+commit.e9db8d9f.linux
	chmod +x ${ZKSYNC_SERVER_HOME}/etc/vyper-bin/v0.4.0/vyper

download-explorer: deps
	git -C ${ZKSYNC_EXPLORER_HOME} pull origin ${EXPLORER_COMMIT}:${EXPLORER_COMMIT} --ff-only 2>/dev/null || git clone ${EXPLORER_REPO} ${ZKSYNC_EXPLORER_HOME}
	git -C ${ZKSYNC_EXPLORER_HOME} checkout ${EXPLORER_COMMIT}
	cp custom_configs/explorer.json ${ZKSYNC_EXPLORER_HOME}/packages/app/src/configs/hyperchain.config.json
	cp diffs/explorer/explorer.diff ${ZKSYNC_EXPLORER_HOME}
	cp -r diffs/explorer/maintenance ${ZKSYNC_EXPLORER_HOME}
	git -C ${ZKSYNC_EXPLORER_HOME} apply explorer.diff || exit 0	

download-portal: deps
	git -C ${ZKSYNC_PORTAL_HOME} pull origin ${PORTAL_COMMIT}:${PORTAL_COMMIT} --ff-only 2>/dev/null || git clone ${PORTAL_REPO} ${ZKSYNC_PORTAL_HOME}
	git -C ${ZKSYNC_PORTAL_HOME} checkout ${PORTAL_COMMIT}
	cp custom_configs/portal.json ${ZKSYNC_PORTAL_HOME}/hyperchains/config.json
	cp custom_configs/portal.env ${ZKSYNC_PORTAL_HOME}/.env
	cp diffs/portal/portal.diff ${ZKSYNC_PORTAL_HOME}
	cp -r diffs/portal/maintenance ${ZKSYNC_PORTAL_HOME}
	git -C ${ZKSYNC_PORTAL_HOME} apply portal.diff || exit 0

download-prover: deps
	git -C ${ZKSYNC_PROVER_HOME} pull origin ${PROVER_COMMIT}:${PROVER_COMMIT} --ff-only 2>/dev/null || git clone ${PROVER_REPO} ${ZKSYNC_PROVER_HOME}
	git -C ${ZKSYNC_PROVER_HOME} checkout ${PROVER_COMMIT}
	cp custom_configs/${ZKSYNC_ENV}.toml ${ZKSYNC_PROVER_HOME}/etc/env/configs/${ZKSYNC_ENV}.toml
	git -C ${BELLMAN_CUDA_HOME} pull origin ${BELLMAN_CUDA_COMMIT}:${BELLMAN_CUDA_COMMIT} --ff-only 2>/dev/null || git clone ${BELLMAN_CUDA_REPO} ${BELLMAN_CUDA_HOME}
	git -C ${BELLMAN_CUDA_HOME} checkout ${BELLMAN_CUDA_COMMIT}
	git -C ${BELLMAN_CUDA_HOME} submodule update --init --recursive

# Setup

setup-all-no-prover: setup-server setup-explorer setup-portal

setup-all: setup-all-no-prover setup-prover

## Server

setup-server: export ZKSYNC_HOME=${ZKSYNC_SERVER_HOME}
setup-server: export DEPLOYER_PRIVATE_KEY=${ZKSYNC_DEPLOYER_PRIVATE_KEY}
setup-server: export GOVERNANCE_PRIVATE_KEY=${ZKSYNC_GOVERNANCE_PRIVATE_KEY}
setup-server: export GOVERNOR_PRIVATE_KEY=${ZKSYNC_GOVERNOR_PRIVATE_KEY}
setup-server: download-server
	sudo chown -R $(USER):$(USER) $(ZKSYNC_SERVER_HOME)
	export PATH=$(ZKSYNC_HOME)/bin:$(PATH) && \
		cd $(ZKSYNC_SERVER_HOME) && \
		./bin/zk && \
		./bin/zk clean --all && \
		./bin/zk env $(ZKSYNC_ENV) && \
		./bin/zk init --run-observability

setup-server-base-token: export ZKSYNC_HOME=${ZKSYNC_SERVER_HOME}
setup-server-base-token: export DEPLOYER_PRIVATE_KEY=${ZKSYNC_DEPLOYER_PRIVATE_KEY}
setup-server-base-token: export GOVERNANCE_PRIVATE_KEY=${ZKSYNC_GOVERNANCE_PRIVATE_KEY}
setup-server-base-token: export GOVERNOR_PRIVATE_KEY=${ZKSYNC_GOVERNOR_PRIVATE_KEY}
setup-server-base-token:
	export PATH=$(ZKSYNC_HOME)/bin:$(PATH) && \
		cd $(ZKSYNC_SERVER_HOME) && \
		./bin/zk && \
		./bin/zk clean --all && \
		./bin/zk env $(ZKSYNC_ENV) && \
		./bin/zk init --run-observability --base-token-name $(ZKSYNC_BASE_TOKEN_NAME)

## Explorer

setup-explorer: export ZKSYNC_HOME=$(ZKSYNC_SERVER_HOME)
setup-explorer: export DATABASE_HOST=127.0.0.1
setup-explorer: export DATABASE_USER=postgres
setup-explorer: export DATABASE_PASSWORD=notsecurepassword
setup-explorer: export DATABASE_URL=postgres://postgres:notsecurepassword@127.0.0.1:5432/block-explorer
setup-explorer: export BLOCKCHAIN_RPC_URL=http://127.0.0.1:3050
setup-explorer: download-explorer
	cd $(ZKSYNC_EXPLORER_HOME) ; npm install
	cd $(ZKSYNC_EXPLORER_HOME)/packages/worker ; npm run db:create || exit 0
	cd $(ZKSYNC_EXPLORER_HOME) ; npm run build

## Portal

setup-portal: download-portal
	echo 'telemetry.enabled=false' > ~/.nuxtrc
	cd $(ZKSYNC_PORTAL_HOME) ; \
		npm install && \
		npm run generate:node:hyperchain

## Prover

setup-prover: FRI_PROVER_SETUP_DATA_PATH=${ZKSYNC_SERVER_HOME}/prover/vk_setup_data_generator_server_fri/data
setup-prover: download-prover
	cp ${ZKSYNC_SERVER_HOME}/etc/env/configs/${ZKSYNC_ENV}.toml ${ZKSYNC_PROVER_HOME}/etc/env/configs/${ZKSYNC_ENV}.toml
	cp -r ${ZKSYNC_SERVER_HOME}/etc/env/l2-inits ${ZKSYNC_PROVER_HOME}/etc/env
	rm -f ${ZKSYNC_PROVER_HOME}/etc/env/target/${ZKSYNC_ENV}.env
	cd ${ZKSYNC_PROVER_HOME}/prover && \
		export ZKSYNC_HOME=${ZKSYNC_PROVER_HOME} && \
		export PATH=${ZKSYNC_PROVER_HOME}/bin:$(PATH) && \
		zk && \
		zk env ${ZKSYNC_ENV} && \
		zk f cargo run --features gpu --release --bin key_generator -- generate-sk-gpu all --recompute-if-missing
	cd ${BELLMAN_CUDA_HOME} ; cmake -B./build -DCMAKE_BUILD_TYPE=Release
	cd ${BELLMAN_CUDA_HOME} ; cmake --build ./build
	wget -O ${BELLMAN_CUDA_HOME}/setup_2^26.key https://storage.googleapis.com/matterlabs-setup-keys-us/setup-keys/setup_2^26.key

# Run

run-server: export ZKSYNC_HOME=$(ZKSYNC_SERVER_HOME)
run-server: $(ZKSYNC_SERVER_HOME)
	export PATH=$(ZKSYNC_HOME)/bin:$(PATH) && \
		cd $(ZKSYNC_SERVER_HOME) && \
		zk server --components=api,eth,tree,state_keeper,housekeeper,commitment_generator,proof_data_handler

run-contract-verifier: export ZKSYNC_HOME=$(ZKSYNC_SERVER_HOME)
run-contract-verifier: $(ZKSYNC_SERVER_HOME)
	cd $(ZKSYNC_SERVER_HOME)/core/bin/contract-verifier && \
		PATH=$(ZKSYNC_SERVER_HOME)/bin:$(PATH) \
		zk f cargo run --release --bin zksync_contract_verifier

run-explorer: export DATABASE_HOST=127.0.0.1
run-explorer: export DATABASE_USER=postgres
run-explorer: export DATABASE_PASSWORD=notsecurepassword
run-explorer: export DATABASE_URL=postgres://postgres:notsecurepassword@127.0.0.1:5432/block-explorer
run-explorer: export BLOCKCHAIN_RPC_URL=http://127.0.0.1:3050
run-explorer: $(ZKSYNC_EXPLORER_HOME)
	cd $(ZKSYNC_EXPLORER_HOME) ; npm run start

run-portal: $(ZKSYNC_PORTAL_HOME)
	cd $(ZKSYNC_PORTAL_HOME) ; npx serve .output/public -p 3002

## Prover

run-prover-gateway: $(ZKSYNC_PROVER_HOME)
	cd $(ZKSYNC_PROVER_HOME)/prover && \
		PATH=$(ZKSYNC_PROVER_HOME)/bin:$(PATH) \
		ZKSYNC_HOME=$(ZKSYNC_PROVER_HOME) \
		zk f cargo run --release --bin zksync_prover_fri_gateway

run-prover-witness-generators: $(ZKSYNC_PROVER_HOME)
	cd $(ZKSYNC_PROVER_HOME)/prover && \
		PATH=$(ZKSYNC_PROVER_HOME)/bin:$(PATH) \
		ZKSYNC_HOME=$(ZKSYNC_PROVER_HOME) \
		API_PROMETHEUS_LISTENER_PORT=3116 \
		zk f cargo run --release --bin zksync_witness_generator -- --all_rounds

WVG_PROMETHEUS_PORT ?= 3420
run-prover-witness-vector-gen: $(ZKSYNC_PROVER_HOME)
	cd $(ZKSYNC_PROVER_HOME)/prover && \
		PATH=$(ZKSYNC_PROVER_HOME)/bin:$(PATH) \
		ZKSYNC_HOME=$(ZKSYNC_PROVER_HOME) \
		FRI_WITNESS_VECTOR_GENERATOR_PROMETHEUS_LISTENER_PORT=$(WVG_PROMETHEUS_PORT) \
		zk f cargo run --release --bin zksync_witness_vector_generator

run-prover-prover: $(ZKSYNC_PROVER_HOME)
	cd $(ZKSYNC_PROVER_HOME)/prover && \
		PATH=$(ZKSYNC_PROVER_HOME)/bin:$(PATH) \
		ZKSYNC_HOME=$(ZKSYNC_PROVER_HOME) \
		zk f env FRI_PROVER_SETUP_DATA_PATH=${ZKSYNC_PROVER_HOME}/prover/vk_setup_data_generator_server_fri/data \
		cargo run --features "gpu" --release --bin zksync_prover_fri

run-prover-compressor: $(ZKSYNC_PROVER_HOME)
	cd $(ZKSYNC_PROVER_HOME)/prover && \
		PATH=$(ZKSYNC_PROVER_HOME)/bin:$(PATH) \
		ZKSYNC_HOME=$(ZKSYNC_PROVER_HOME) \
		zk f cargo run --release --bin zksync_proof_fri_compressor

run-prover-compressor-gpu: $(ZKSYNC_PROVER_HOME)
	cd $(ZKSYNC_PROVER_HOME)/prover && \
		PATH=$(ZKSYNC_PROVER_HOME)/bin:$(PATH) \
		ZKSYNC_HOME=$(ZKSYNC_PROVER_HOME) \
		BELLMAN_CUDA_DIR=$(BELLMAN_CUDA_HOME) \
		CRS_FILE=$(BELLMAN_CUDA_HOME)/setup_2^26.key \
		zk f cargo run --features "gpu" --release --bin zksync_proof_fri_compressor

# Main

up-no-prover: server explorer portal

up: up-no-prover prover-all

server: download-server
	tmux kill-session -t server 2>/dev/null || exit 0
	tmux new -d -s server
	tmux send-keys -t server "make setup-server run-server" Enter
	sleep 5
	tmux kill-session -t contract-verifier 2>/dev/null || exit 0
	tmux new -d -s contract-verifier
	tmux send-keys -t contract-verifier "make run-contract-verifier"

server-base-token: download-server
	tmux kill-session -t server 2>/dev/null || exit 0
	tmux new -d -s server
	tmux send-keys -t server "make setup-server-base-token run-server" Enter
	sleep 5
	tmux kill-session -t contract-verifier 2>/dev/null || exit 0
	tmux new -d -s contract-verifier
	tmux send-keys -t contract-verifier "make run-contract-verifier"

explorer:
	tmux kill-session -t explorer 2>/dev/null || exit 0
	tmux new -d -s explorer
	tmux send-keys -t explorer "make setup-explorer run-explorer" Enter

portal:
	tmux kill-session -t portal 2>/dev/null || exit 0
	tmux new -d -s portal
	tmux send-keys -t portal "make setup-portal run-portal" Enter

## Prover

prover-gateway:
	tmux kill-session -t pg 2>/dev/null || exit 0
	tmux new -d -s pg
	tmux send-keys -t pg "make setup-prover run-prover-gateway" Enter

prover-witness-generator:
	tmux kill-session -t pwg 2>/dev/null || exit 0
	tmux new -d -s pwg
	tmux send-keys -t pwg "make setup-prover run-prover-witness-generator" Enter

prover-witness-vector-gen:
	tmux kill-session -t pwv 2>/dev/null || exit 0
	tmux new -d -s pwv
	tmux send-keys -t pwv "make setup-prover run-prover-witness-vector-gen" Enter

prover-prover:
	tmux kill-session -t pp 2>/dev/null || exit 0
	tmux new -d -s pp
	tmux send-keys -t pp "make setup-prover run-prover-prover" Enter

prover-compressor:
	tmux kill-session -t pc 2>/dev/null || exit 0
	tmux new -d -s pc
	tmux send-keys -t pc "make setup-prover run-prover-compressor" Enter

prover-all: prover-gateway prover-witness-generator prover-witness-vector-gen prover-prover prover-compressor
