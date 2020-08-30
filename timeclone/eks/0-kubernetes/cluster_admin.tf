# locals {
#   admins = [
#     data.terraform_remote_state.timeclone_iam.outputs.iam_user_ratnam.this_iam_user_arn,
#   ]
# }

# resource "kubernetes_cluster_role_binding" "dev_eks_ugen_admin" {
#   metadata {
#     name = "dev-eks-ugen-admin"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = "cluster-admin"
#   }

#   dynamic subject {
#     for_each = local.admins
#     content {
#       kind      = "User"
#       name      = subject.value
#       api_group = "rbac.authorization.k8s.io"
#     }
#   }
# }
