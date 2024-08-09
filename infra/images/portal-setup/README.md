1. Configure the `config.json` file with your hyperchain data (The docs of the dapp-portal repo explain how to do this).
2. Change the `BRANCH` and `REPO_URL` as needed
3. Run the `push-image.sh` script, it will build and push the image to the registry you desire:

```sh
sh push-image.sh ihc-testnet-v0.0.1 us-central1-docker.pkg.dev/zksync-413615/zksync
```
