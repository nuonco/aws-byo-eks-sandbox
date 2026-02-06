locals {
  cluster_name = var.cluster_name

  access_entries = {
    "provision" = {
      principal_arn       = var.provision_iam_role_arn
      kubernetes_groups   = concat(["provision"], var.provision_role_eks_kubernetes_groups)
      policy_associations = var.provision_role_eks_access_entry_policy_associations,
    },
    "maintenance" = {
      principal_arn       = var.maintenance_iam_role_arn
      kubernetes_groups   = concat(["maintenance"], var.maintenance_role_eks_kubernetes_groups)
      policy_associations = var.maintenance_role_eks_access_entry_policy_associations,
    },
    "deprovision" = {
      principal_arn       = var.deprovision_iam_role_arn
      kubernetes_groups   = concat(["deprovision"], var.deprovision_role_eks_kubernetes_groups)
      policy_associations = var.deprovision_role_eks_access_entry_policy_associations,
    },
  }

  all_access_entries = merge(local.access_entries, var.additional_access_entry)
}

resource "aws_eks_access_entry" "nuon" {
  for_each = local.all_access_entries

  cluster_name  = local.cluster_name
  principal_arn = each.value.principal_arn
  type          = "STANDARD"

  tags = local.tags

  depends_on = [
    aws_security_group_rule.runner_cluster_access,
  ]
}

locals {
  policy_associations_flat = flatten([
    for entry_key, entry in local.all_access_entries : [
      for policy_key, policy in lookup(entry, "policy_associations", {}) : {
        key           = "${entry_key}-${policy_key}"
        entry_key     = entry_key
        principal_arn = entry.principal_arn
        policy_arn    = policy.policy_arn
        access_scope  = policy.access_scope
      }
    ]
  ])
  policy_associations_map = { for p in local.policy_associations_flat : p.key => p }
}

resource "aws_eks_access_policy_association" "nuon" {
  for_each = local.policy_associations_map

  cluster_name  = local.cluster_name
  principal_arn = each.value.principal_arn
  policy_arn    = each.value.policy_arn

  access_scope {
    type       = each.value.access_scope.type
    namespaces = lookup(each.value.access_scope, "namespaces", null)
  }

  depends_on = [aws_eks_access_entry.nuon]
}
