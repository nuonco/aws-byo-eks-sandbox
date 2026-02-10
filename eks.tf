# in the byo-eks sandbox, the cluster is not created. it's simply read and its facts
# are munged into outputs in the expectd format.
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}
