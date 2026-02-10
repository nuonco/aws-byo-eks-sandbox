locals {
  # subnet IDs from comma-delimited inputs
  public_subnet_ids  = var.public_subnet_ids != "" ? split(",", var.public_subnet_ids) : []
  private_subnet_ids = split(",", var.private_subnet_ids)
  runner_subnet_id   = var.runner_subnet_id

  # kyverno
  enable_kyverno = contains(["1", "true"], var.enable_kyverno)

  # nuon dns
  enable_nuon_dns = contains(["1", "true"], var.enable_nuon_dns)
  nuon_dns = {
    enabled              = local.enable_nuon_dns
    internal_root_domain = var.internal_root_domain
    public_root_domain   = var.public_root_domain
  }

  # tags for all of the resources
  default_tags = merge(var.tags, {
    "install.nuon.co/id"   = var.nuon_id
    "sandbox.nuon.co/name" = "aws-byo-eks"
  })
  tags = merge(
    var.additional_tags,
    local.default_tags,
  )

  roles = {
    provision_iam_role_name   = split("/", var.provision_iam_role_arn)[length(split("/", var.provision_iam_role_arn)) - 1]
    deprovision_iam_role_name = split("/", var.deprovision_iam_role_arn)[length(split("/", var.deprovision_iam_role_arn)) - 1]
    maintenance_iam_role_name = split("/", var.maintenance_iam_role_arn)[length(split("/", var.maintenance_iam_role_arn)) - 1]
  }
}

#
# from cloudformation
#

variable "vpc_id" {
  type        = string
  description = "The ID of the AWS VPC to provision the sandbox in."
}

#
# values from cloudformation install stack
#

variable "maintenance_iam_role_arn" {
  type        = string
  description = "The provision IAM Role ARN"
}

variable "provision_iam_role_arn" {
  type        = string
  description = "The maintenance IAM Role ARN"
}

variable "deprovision_iam_role_arn" {
  type        = string
  description = "The deprovision IAM Role ARN"
}

#
# vendor defined via app config
#

# kyverno
variable "enable_kyverno" {
  type        = string
  default     = "false"
  description = "Whether or not to install Kyverno and its policies."
}

variable "kyverno_policy_dir" {
  type        = string
  description = "Path to a directory with kyverno policy manifests."
  default     = "./kyverno-policies"
}

#
# install inputs
#

# cluster details
variable "cluster_name" {
  type        = string
  description = "The name of the existing EKS cluster to use."
}

variable "public_subnet_ids" {
  type        = string
  description = "Comma-delimited list of public subnet IDs. Can be empty."
  default     = ""
}

variable "private_subnet_ids" {
  type        = string
  description = "Comma-delimited list of private subnet IDs. Should not be empty."
}

variable "runner_subnet_id" {
  type        = string
  description = "Single subnet ID for the runner. Should not be empty."
}


variable "additional_tags" {
  type        = map(any)
  description = "Extra tags to append to the default tags that will be added to install resources."
  default     = {}
}

variable "helm_driver" {
  type        = string
  description = "One of 'configmap' or 'secret'"
  default     = "secret"
}

#
# toggle-able components
#

# Nuon DNS
variable "enable_nuon_dns" {
  type        = string
  default     = "false"
  description = "Whether or not the cluster should use a nuon-provided nuon.run domain. Controls the cert-manager-issuer and the route_53_zone."
}

#
# set by nuon
#

variable "nuon_id" {
  type        = string
  description = "The nuon id for this install. Used for naming purposes."
}

variable "region" {
  type        = string
  description = "The region to launch the cluster in."
}

# DNS
variable "public_root_domain" {
  type        = string
  description = "The public root domain."
}

# NOTE: if you would like to create an internal load balancer, with TLS, you will have to use the public domain.
variable "internal_root_domain" {
  type        = string
  description = "The internal root domain."
}

variable "tags" {
  type        = map(any)
  description = "List of custom tags to add to the install resources. Used for taxonomic purposes."
}
