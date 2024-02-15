output "stag_eks_cluster" {
  value = module.this
}

output "stag_eks_oidc" {
  value = module.this.oidc_provider
}
