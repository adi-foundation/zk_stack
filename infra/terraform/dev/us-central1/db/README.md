<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.35.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_sql_database_instance.zksync_dev_01](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/sql_database_instance) | resource |
| [google_sql_database_instance.zksync_dev_prover_01](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/sql_database_instance) | resource |
| [google_sql_database_instance.zksync_en_dev_01](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/sql_database_instance) | resource |
| [google_sql_user.lambda](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/sql_user) | resource |
| [google_sql_user.lambda-en](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/sql_user) | resource |
| [google_sql_user.lambda_prover](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/sql_user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_en_sql_password"></a> [en\_sql\_password](#input\_en\_sql\_password) | n/a | `string` | n/a | yes |
| <a name="input_sql_password"></a> [sql\_password](#input\_sql\_password) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sql-instances-public-ips"></a> [sql-instances-public-ips](#output\_sql-instances-public-ips) | n/a |
<!-- END_TF_DOCS -->