# AMP

we have copied the contents of ../aws-eks-sandbox into this new directory aws-byo-eks.

the goal here is to have a nearly identical sandbox except we'll want the eks k8s cluster to actually be a pass through
data resource that just reads the cluster info.

the outputs should remain the same.

acecpt the subnets as lists and use a local at the top of variables.tf to split them into an array.

data.tf should populate the subnet values that we use in other resources with these ids in data resources as opposed to
fetching them by tag convention.

## Major differences:

- new required input `cluster_name`.
- new required input `public_subnet_ids` comma delimited list. (list can be empty)
- new required input `private_subnet_ids` comma delimited list (should not be empty)
- new required input `runner_subnet_ids` single subnet id (should not empty)
- eks is a pass through: aka it's just read as a data soruce.
- access entries for nuon roles is created here
- rbac roles are also created here for the roles.
- subnets are fetched by id instead of by tag convention.

- removed ebs csi controller
