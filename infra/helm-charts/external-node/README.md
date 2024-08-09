# How

To install the helm chart(deploy all the manifests):

```sh
helm install external-node . --values values.yaml
```

If there are some changes, you can use `upgrade`. Helm will change only what it needs:

```sh
helm upgrade external-node . --values values.yaml --debug
```

If you want to delete the installed helm chart use `delete`:

```sh
helm delete external-node
```
