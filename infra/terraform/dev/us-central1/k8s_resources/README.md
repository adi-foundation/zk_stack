<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.14.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.31.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.en-grafana-deployment](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.en-grafana-service](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.grafana-service](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.basic-witness-generator-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.cluster-secret-store-gcp](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.contract-verifier-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.en-backend](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.en-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.en-grafana-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.en-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.en-service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.explorer-api-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.explorer-api-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.explorer-api-service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.explorer-app-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.explorer-app-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.explorer-app-service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.explorer-data-fetcher-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.explorer-data-fetcher-service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.explorer-worker-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.grafana-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.grafana-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.grafana-pvc](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.leaf-witness-generator-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.node-witness-generator-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.portal-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.portal-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.portal-service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.prover-compressor-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.prover-gateway-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.prover-prover-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.prover-witness-vector-generator-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.recursion-tip-witness-generator-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.scheduler-witness-generator-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.server-backend](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.server-deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.server-ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.server-service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.snapshots-creator-cronjob](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->