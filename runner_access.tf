data "aws_security_groups" "runner" {
  tags = {
    "network.nuon.co/domain" = "runner"
    "install.nuon.co/id"     = var.nuon_id
  }
}

resource "aws_security_group_rule" "runner_cluster_access" {
  type                     = "ingress"
  description              = "Allow ingress traffic from runner."
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = data.aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  source_security_group_id = data.aws_security_groups.runner.ids[0]
}
