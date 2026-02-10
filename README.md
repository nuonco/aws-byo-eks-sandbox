# Nuon AWS BYO-EKS Sandbox

Sandbox for apps that are deployed into an existing EKS Cluster. Typically paired with the nuon `byo-vpc`
[cloudformation VPC Template](https://github.com/nuonco/aws-cloudformation-templates/tree/main/vpc/eks).

## Notes

This module incldues `nuon_dns` but it should be used with extreme care. it is disabled by default and should only be
enabled with the customer's explicit consent given it installs a number of helm charts which may conflict with existing
networking resources.

The cluster has storage and networking drivers and classes or CRDs. This sandbox is not concerned with installing any
resources of this type.

<!-- terraform-docs markdown table . -->

## Requirements

| Name                                                                        | Version   |
| --------------------------------------------------------------------------- | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform)    | >= 1.14.3 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                      | = 5.94.1  |
| <a name="requirement_helm"></a> [helm](#requirement_helm)                   | = 2.17.0  |
| <a name="requirement_kubectl"></a> [kubectl](#requirement_kubectl)          | = 1.19    |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement_kubernetes) | = 2.36.0  |

## Providers

| Name                                                                        | Version |
| --------------------------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                            | 5.94.1  |
| <a name="provider_helm.main"></a> [helm.main](#provider_helm.main)          | 2.17.0  |
| <a name="provider_kubectl.main"></a> [kubectl.main](#provider_kubectl.main) | 1.19.0  |

## Modules

| Name                                                        | Source                        | Version |
| ----------------------------------------------------------- | ----------------------------- | ------- |
| <a name="module_ecr"></a> [ecr](#module_ecr)                | terraform-aws-modules/ecr/aws | 2.4.0   |
| <a name="module_nuon_dns"></a> [nuon_dns](#module_nuon_dns) | ./nuon_dns                    | n/a     |

## Resources

| Name                                                                                                                                                            | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_policy.ecr_access](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/resources/iam_policy)                                             | resource    |
| [aws_iam_role_policy_attachment.ecr_access_deprovision](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_role_policy_attachment.ecr_access_maintenance](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_role_policy_attachment.ecr_access_provision](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/resources/iam_role_policy_attachment)   | resource    |
| [helm_release.kyverno](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release)                                                    | resource    |
| [kubectl_manifest.default_policies](https://registry.terraform.io/providers/gavinbunney/kubectl/1.19/docs/resources/manifest)                                   | resource    |
| [kubectl_manifest.namespaces](https://registry.terraform.io/providers/gavinbunney/kubectl/1.19/docs/resources/manifest)                                         | resource    |
| [kubectl_manifest.vendor_policies](https://registry.terraform.io/providers/gavinbunney/kubectl/1.19/docs/resources/manifest)                                    | resource    |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/data-sources/availability_zones)                           | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/data-sources/caller_identity)                                   | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/data-sources/eks_cluster)                                           | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/data-sources/eks_cluster_auth)                                 | data source |
| [aws_iam_openid_connect_provider.cluster](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/data-sources/iam_openid_connect_provider)           | data source |
| [aws_iam_policy_document.ecr](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/data-sources/iam_policy_document)                               | data source |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/data-sources/security_group)                                     | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/data-sources/subnet)                                                     | data source |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/data-sources/subnet)                                                      | data source |
| [aws_subnet.runner](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/data-sources/subnet)                                                      | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/data-sources/vpc)                                                               | data source |

## Inputs

| Name                                                                                                      | Description                                                                                                                    | Type                                                                                                               | Default                | Required |
| --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------ | ---------------------- | :------: |
| <a name="input_additional_irsas"></a> [additional_irsas](#input_additional_irsas)                         | List of additional IRSA accounts to create.                                                                                    | <pre>list(object({<br/> role_name = string,<br/> namespace = string,<br/> service_account = string,<br/> }))</pre> | `[]`                   |    no    |
| <a name="input_additional_namespaces"></a> [additional_namespaces](#input_additional_namespaces)          | A list of namespaces that should be created on the cluster. The `{{.nuon.install.id}}` namespace is created by default.        | `list(string)`                                                                                                     | `[]`                   |    no    |
| <a name="input_additional_tags"></a> [additional_tags](#input_additional_tags)                            | Extra tags to append to the default tags that will be added to install resources.                                              | `map(any)`                                                                                                         | `{}`                   |    no    |
| <a name="input_cluster_name"></a> [cluster_name](#input_cluster_name)                                     | The name of the existing EKS cluster to use.                                                                                   | `string`                                                                                                           | n/a                    |   yes    |
| <a name="input_deprovision_iam_role_arn"></a> [deprovision_iam_role_arn](#input_deprovision_iam_role_arn) | The deprovision IAM Role ARN                                                                                                   | `string`                                                                                                           | n/a                    |   yes    |
| <a name="input_enable_kyverno"></a> [enable_kyverno](#input_enable_kyverno)                               | Whether or not to install Kyverno and its policies.                                                                            | `string`                                                                                                           | `"false"`              |    no    |
| <a name="input_enable_nuon_dns"></a> [enable_nuon_dns](#input_enable_nuon_dns)                            | Whether or not the cluster should use a nuon-provided nuon.run domain. Controls the cert-manager-issuer and the route_53_zone. | `string`                                                                                                           | `"false"`              |    no    |
| <a name="input_helm_driver"></a> [helm_driver](#input_helm_driver)                                        | One of 'configmap' or 'secret'                                                                                                 | `string`                                                                                                           | `"secret"`             |    no    |
| <a name="input_internal_root_domain"></a> [internal_root_domain](#input_internal_root_domain)             | The internal root domain.                                                                                                      | `string`                                                                                                           | n/a                    |   yes    |
| <a name="input_kyverno_policy_dir"></a> [kyverno_policy_dir](#input_kyverno_policy_dir)                   | Path to a directory with kyverno policy manifests.                                                                             | `string`                                                                                                           | `"./kyverno-policies"` |    no    |
| <a name="input_maintenance_iam_role_arn"></a> [maintenance_iam_role_arn](#input_maintenance_iam_role_arn) | The provision IAM Role ARN                                                                                                     | `string`                                                                                                           | n/a                    |   yes    |
| <a name="input_nuon_id"></a> [nuon_id](#input_nuon_id)                                                    | The nuon id for this install. Used for naming purposes.                                                                        | `string`                                                                                                           | n/a                    |   yes    |
| <a name="input_private_subnet_ids"></a> [private_subnet_ids](#input_private_subnet_ids)                   | Comma-delimited list of private subnet IDs. Should not be empty.                                                               | `string`                                                                                                           | n/a                    |   yes    |
| <a name="input_provision_iam_role_arn"></a> [provision_iam_role_arn](#input_provision_iam_role_arn)       | The maintenance IAM Role ARN                                                                                                   | `string`                                                                                                           | n/a                    |   yes    |
| <a name="input_public_root_domain"></a> [public_root_domain](#input_public_root_domain)                   | The public root domain.                                                                                                        | `string`                                                                                                           | n/a                    |   yes    |
| <a name="input_public_subnet_ids"></a> [public_subnet_ids](#input_public_subnet_ids)                      | Comma-delimited list of public subnet IDs. Can be empty.                                                                       | `string`                                                                                                           | `""`                   |    no    |
| <a name="input_region"></a> [region](#input_region)                                                       | The region to launch the cluster in.                                                                                           | `string`                                                                                                           | n/a                    |   yes    |
| <a name="input_runner_subnet_id"></a> [runner_subnet_id](#input_runner_subnet_id)                         | Single subnet ID for the runner. Should not be empty.                                                                          | `string`                                                                                                           | n/a                    |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                                             | List of custom tags to add to the install resources. Used for taxonomic purposes.                                              | `map(any)`                                                                                                         | n/a                    |   yes    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                                       | The ID of the AWS VPC to provision the sandbox in.                                                                             | `string`                                                                                                           | n/a                    |   yes    |

## Outputs

| Name                                                              | Description                                                                                                                                                                            |
| ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <a name="output_account"></a> [account](#output_account)          | A map of AWS account attributes: id, region.                                                                                                                                           |
| <a name="output_cluster"></a> [cluster](#output_cluster)          | A map of EKS cluster attributes: arn, certificate_authority_data, endpoint, name, platform_version, status, oidc_issuer_url, oidc_provider_arn, cluster_security_group_id.             |
| <a name="output_ecr"></a> [ecr](#output_ecr)                      | A map of ECR attributes: repository_url, repository_arn, repository_name, registry_id, registry_url.                                                                                   |
| <a name="output_namespaces"></a> [namespaces](#output_namespaces) | A list of namespaces that were created by this module.                                                                                                                                 |
| <a name="output_nuon_dns"></a> [nuon_dns](#output_nuon_dns)       | A map of Nuon DNS attributes: whether nuon.run has been enabled; AWS Route 53 details for the public_domain and internal_domain; metadata bout the helm charts the module installs on. |
| <a name="output_vpc"></a> [vpc](#output_vpc)                      | A map of vpc attributes: name, id, cidr, azs, private_subnet_cidr_blocks, private_subnet_ids, public_subnet_cidr_blocks, public_subnet_ids, default_security_group_id.                 |
