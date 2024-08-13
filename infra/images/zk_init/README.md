# ZK init

This image clones the zksync-era repo and runs a `zk init` that launch a new chain. Once launched, it creates a ConfigMap with the env to the cluster. It's used among `infra/kubernetes/jobs/zk_init.yaml`.

To build and push the image, run:

```sh
docker build -t us-central1-docker.pkg.dev/zksync-413615/zksync/zk-init:latest --platform=linux/amd64 .
docker push us-central1-docker.pkg.dev/zksync-413615/zksync/zk-init
```

The `zk-init` job requires a ConfigMap with a `custom.toml` file, containing the chain config. Check `infra/kubernetes/configmaps/zk_init.yaml` for more details.

### Base Token

If you want to deploy a Base Token based network, you need to add the `BASE_TOKEN_SYMBOL` env var to the job, among with the `contracts.base_token_addr` config on the `custom.toml` file.

> [!WARNING]
> Currently, the WETH address is mocked with an example, you may need to change it. Take a look at `init.sh`.
