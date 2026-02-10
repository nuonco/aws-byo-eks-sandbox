data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet" "public" {
  for_each = toset(local.public_subnet_ids)
  id       = each.key
}

data "aws_subnet" "private" {
  for_each = toset(local.private_subnet_ids)
  id       = each.key
}

data "aws_subnet" "runner" {
  id = local.runner_subnet_id
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.vpc.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_iam_openid_connect_provider" "cluster" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

locals {
  subnets = {
    private = {
      ids   = local.private_subnet_ids,
      cidrs = [for s in data.aws_subnet.private : s.cidr_block],
    }
    public = {
      ids   = local.public_subnet_ids,
      cidrs = [for s in data.aws_subnet.public : s.cidr_block],
    }
    runner = {
      ids   = [local.runner_subnet_id]
      cidrs = [data.aws_subnet.runner.cidr_block]
    }
  }
}
