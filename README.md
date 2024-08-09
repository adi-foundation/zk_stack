# ZK Stack

A Custom Zk Stack version based on the [zksync-era repo](https://github.com/matter-labs/zksync-era) to easily deploy a zk-rollup on bare-metal or cloud infra.

## Table of contents
- [zkSync Stack](#zksync-stack)
    - [Running the stack with kubernetes](#running-the-stack-with-kubernetes)
        - [Requirements](#k8s-requirements)
        - [Manifests](#manifests)
        - [Terraform](#terraform)
    - [Running the stack locally](#running-the-stack-locally)
        - [Requirements](#local-requirements)
        - [Before running the stack (configuration)](#before-running-the-stack-configuration)
        - [Running the stack without GPU prover](#running-the-stack-without-gpu-prover)
        - [Running the stack with a GPU prover](#running-the-stack-with-a-gpu-prover)
        - [Local Nodes](#local-nodes)
        - [Block Explorer](#block-explorer)
        - [Portal](#portal)
        - [Grafana and Observability](#grafana-and-observability)
        - [Prover](#prover)
    - [Config reference](#config-reference)

## Running the stack with kubernetes

The following scheme was tested on a GCP GKE cluster with a `g2-standard-32` GPU node and 2 `c3-highmem-22` CPU nodes

<span id="k8s-requirements"></span>
### Requirements

A PostgreSQL database accesible by the cluster is needed.

Before starting, you need an `.env` file with an initialized network (i.e. `etc/env/target/<ZKSYNC_ENV>.env`). Although we are currently working on completing the launch cycle with an init job, for now you need to run a `zk init` locally to generate that `.env`. Once you get your file, you have to upload it to the cluster as a ConfigMap with name `env-configmap`. You can do that with:

```sh
kubectl create configmap env-configmap --from-env-file=file.env
```

Make sure to update all necessary fields.

Also, you will need some GCP buckets that have to be on your `.env` file:

- OBJECT_STORE
- PUBLIC_OBJECT_STORE
- PROVER_OBJECT_STORE
- SNAPSHOTS_OBJECT_STORE

### Manifests

To launch the system with kubernetes, you need to apply all manifest on `infra/kubernetes`. In the case of the server, you can choose between ETH-based server (`server.yaml`) and base token server (`server-base-token.yaml`). Check deployment resources to see available env vars in each case. Also, make sure to change the ingress manifiests accordingly to your needs.

### Terraform

You can create all the cluster components (except for the `env-configmap` for now) with Terraform. For that, you can instantiate the module we created like shown below. This will create a GKE cluster (with cert-manager and external-secrets operators installed), GCP Global IPs for each service, AWS Route53 DNSs for each IP, and GCS buckets. The GKE cluster will have 2 node pools, CPU and GPU.

You can find more information about what each parameter means by going into the [module's README](./infra/terraform/modules/zk_stack/README.md)

```terraform
module "zk_stack" {
  source = "git::https://github.com/lambdaclass/zk_stack//infra/terraform/modules/zk_stack"

  region       = "us-central1"
  cluster_name = "zksync-dev-01"
  project_id   = "zksync-413615"

  # Nodes configs
  cpu_nodes_locations = "us-central1-a"
  gpu_nodes_locations = "us-central1-c"

  # DNS configuration
  aws_dns_zone                       = "zk-stack.lambdaclass.com"
  explorer_sepolia_dns               = "kube.explorer.sepolia"
  explorer_api_sepolia_dns           = "kube.explorer.api.sepolia"
  portal_sepolia_dns                 = "kube.portal.sepolia"
  rpc_sepolia_dns                    = "kube.rpc.sepolia"
  grafana_sepolia_dns                = "kube.grafana.sepolia"
  external_node_sepolia_dns          = "kube.en01.rpc.sepolia"
  external_node_grafana_sepolia_dns  = "kube.en01.grafana.sepolia"

  # IP configuration
  explorer_app_ip_name  = "explorer-app-ip"
  explorer_api_ip_name  = "explorer-api-ip"
  portal_ip_name        = "portal-ip"
  server_ip_name        = "server-ip"
  grafana_ip_name       = "grafana-ip"
  external_node_ip_name = "external-node-ip"
  en_grafana_ip_name    = "en01-grafana-ip"

  # Storage Buckets configuration
  object_store_bucket_name           = "object-store-dev"
  public_object_store_bucket_name    = "public-object-store-dev"
  prover_object_store_bucket_name    = "prover-object-store-dev"
  snapshots_object_store_bucket_name = "snapshots-object-store-dev"
  prover_setup_data_bucket_name      = "prover-setup-data"
}

terraform {
  required_version = ">= 1.9.0"

  backend "gcs" {
    bucket  = "<YOUR_STATE_BUCKET_HERE"
    prefix  = "<YOUR_STATE_SUBPATH_HERE"
  }
}

provider "google" {
  project = "<YOUR_GCP_PROJECT_HERE>"
}
```

## Running the stack locally

<span id="local-requirements"></span>
### Requirements

- Docker
- Rust
- Node.js + yarn

If you want to simplify the installation of dependencies, running the following command will install almost all of them, except from Docker:

```
make deps
```

If you are facing problems with this, please refer to the [zksync-era repo guide](https://github.com/matter-labs/zksync-era/blob/core-v24.7.0/docs/guides/setup-dev.md)

### Before running the stack (configuration)

Before running the stack we need to set up the configuration files. To do this, create a `config.json` file at the root of the project and populate it with your config, an example can be found on `config.example.json`. Then, run the following command:

```
bash setup.sh
```

This will create a `custom_configs` directory with all the configuration files needed to run the stack, and it also will slightly modify the `Makefile` with some env vars.

Below on this document you can find a complete reference of all configuration options.

### Running the stack without GPU prover

You can launch every service of the stack with the Makefile. The basic structure is something as follows, but we give more detailed information below:

![image](https://github.com/lambdaclass/zksync_stack/assets/30054528/2bcd8926-5719-4e46-983d-a6e135e7305b)

**The following instructions are meant for running the stack without a prover, if you want to run the stack with a GPU prover go to the next section**

To get started, we need to setup all the projects we'll be using. This can be done by running the following command:

```
make setup-all-no-prover
```

This command only installs the dependencies required for running the observability tools over the stack (Prometheus, Grafana). In the future, we'll add the installation for the dependencies needed to run this from a fresh new machine.

This command will download all the repositories needed to run the stack without a GPU prover in addition to the explorer and the portal.

Take in account that this step runs a `zk init`, so should be run only once, unless you want to re-init the chain. If you want to setup again the explorer and portal, you have the targets `setup-explorer` and `setup-portal`.

After the setup is complete, you can start the stack by running each of these commands:

```
make run-server
make run-explorer
make run-portal
```

Note that this are blocking commands, so you may need to run it in different sessions.

Additionally, there's a target that do all this things (including setup) for you and put them on separate tmux sessions: 

```
make up-no-prover
```

### Running the stack with a GPU prover

> #### System Requirements
>
> Running a GPU prover requires a CUDA 12.0 installation as a pre-requisite, alongside these machine specs:
>
> - **CPU:** At least 16 physical cores.
> - **RAM:** 85GB of RAM.
> - **Disk:** 200GB of free disk (lower might be fine, depending on how many proofs you want to generate).
>- **GPU:** NVIDIA GPU with CUDA support and at least 6GB of VRAM, we recommend using GPUs with at least 16GB VRAM for optimal performance. In our GPU picks for data centers while running on Google Cloud Platform, the L4 takes the top spot in terms of price-to-performance ratio, with the T4 coming in second.

Running the following commands will set up the stack with a GPU prover:

```
make setup-all
```

> `setup-all-prover` does the same as `setup-all-no-prover`, but it also downloads the repositories needed to run the stack with a GPU prover, and it generates the universal setup keys.

Then you have the following blocking targets to run every component of the prover:

```
make run-prover-gateway
make run-prover-witness-generator
make run-prover-witness-vector-get
make run-prover-prover
make run-prover-compressor
```

Again, if you want to do all in one command (including setup, server, explorer and portal), you have the target:

```
make up
```

#### GPU Compressor

The compressor has a GPU variant, which can be run by:

```
make run-prover-compressor-gpu
```

This is not the default when running `make up` because generally the GPU doesn't support both prover and compressor together due to lack of memory.

### Local Nodes

The mentioned command facilitates the creation of essential Docker containers for your development environment. This includes setting up a `PostgreSQL` database and the L1 local Geth node. Moreover, it compiles and deploys all the necessary contracts for the L2 local node to function. Please note that this process may take a moment to complete.

In this context, it's essential to mention that many of the tools used will take control of the terminal. Therefore, we've installed `tmux` in the previous step to manage different commands and sessions for each tool. For the L2 node, the session is named `server`. To view the logs and observe the server in action, you can use the following command: `tmux a -t server`.

The L1 Geth node runs at `http://localhost:8545`, while the L2 node is available at `http://localhost:3050`.

### Block Explorer

The development environment includes a block explorer to inspect transactions and proofs within the nodes. This explorer runs within a `tmux` session named `explorer`. You can view it by executing the following command: `tmux a -t explorer`. To access the explorer in your web browser, navigate to `http://localhost:3010`.

Additionally, you can access the API at `http:localhost/3020` and the worker at `http://localhost:3001`.

### Portal

The portal serves you to bridge ETH and tokens between L1 and L2. This portal runs within a `tmux` session named `portal`. You can view it by executing the following command: `tmux a -t portal`. To access the portal in your web browser, navigate to `http://localhost:3002`.

### Grafana and Observability

Other Docker containers are running Grafana and Prometheus, tools for monitoring and creating dashboards. To access a helpful dashboard that provides information about every transaction executed by the node, open your web browser and visit `http://localhost:3000`. Once in that page, click on the hamburger menu on the top left of the screen, on the menu that will slide on, head on over to "Dashboards" to see the available dashboards.

### Prover

When the stack is initiated in prover mode, various binaries execute, each containing one of the tools involved in the process of block proof generation. Here's a list of all the binaries and different components being executed, along with their corresponding `tmux` session since all these components take control of the terminal:

- **Prover**: The main prover. The `tmux` session for this part is `pp`.
- **Prover gateway**: Acts as a communication layer between the server running the state keeper and the proving subsystem. The `tmux` session for this part is `pg`.
- **Witness generators**: Responsible for creating prover jobs. The `tmux` session for this part is `pwg`.
- **Witness vector generator**: Responsible for creating prover jobs. The `tmux` session for this part is `pwv`.
- **Proof compressor**: The final step that compresses/wraps the FRI proof into a SNARK. The `tmux` session for this part is `pc`.

## Config reference

The `config.json` file accepts the following elements. All of them are required except it says **optional**.

- `explorer`:
    - `api_url` (**string**): The URL for the explorer API
    - `web_url` (**string**): The URL for the explorer web
    - `hostnames` (**string[]**): A list of hostnames for the explorer
- `network`:
    - `l1`:
        - `rpc_url` (**string**): The URL of the L1 RPC
        - `name` (**string**): The name of the L1 network
        - `chain_id` (**integer**): Chain ID of the L1 network
    - `l2`:
        - `rpc_url` (**string**): The URL of the L2 RPC
        - `name` (**string**): The name of the L2 network
        - `chain_id` (**integer**): Chain ID of the L2 network
    - `env_name` (**string**): Name of the zkstack environment
    - `prover` (**boolean**): Use GPU prover or skip proofs
    - `operator_private_key` (**string**): Commitment operator private key
    - `operator_commit_eth_addr` (**string**): Commitment operator address
    - `operator_blobs_private_key` (**string**): Blobs operator private key
    - `operator_blobs_eth_addr` (**string**): Blobs operator address
    - `fee_account_private_key` (**string**): Fee account private key
    - `fee_account_addr` (**string**): Fee account address
    - `deployer_private_key` (**string**): Deployer private key
    - `governance_private_key` (**string**): Governance private key
    - `governor_private_key` (**string**): Governor private key
- `portal`:
    - `web_url` (**string**): The URL for the portal web
    - `wallet_connect_apikey` (**string**): API key for wallet connect
    - `ankr_token` (**string**): API key for ANKR. It can be an empty string
    - `extra_tokens` (**list**): List of extra ERC20 tokens that will always appear on the portal. It can be an empty list
        - `address` (**string | optional**): L2 address of the token
        - `l1Address` (**string**): L1 address of the token
        - `symbol` (**string**): Token symbol
        - `name` (**string**): Token name
        - `decimals` (**integer**): Token decimals
        - `iconUrl` (**string | optional**): The URL of the token icon. The root for absolute paths is `portal/public`
