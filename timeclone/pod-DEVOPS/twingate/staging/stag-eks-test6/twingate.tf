#########################################################################################################
# Retrieve Twingate Token Access from AWS Secret Manager
#########################################################################################################
# Get Secret
data "aws_secretsmanager_secret_version" "get_twingate" {
  secret_id = data.terraform_remote_state.devops_staging_secretmanager.outputs.secret_twingate.id
}

#########################################################################################################
# Helm -  Primary Connector Twingate
# ref: https://artifacthub.io/packages/helm/connector/connector
#########################################################################################################
resource "helm_release" "twingate" {
  name             = "twingate-pastel-coati"
  namespace        = "vpn"
  create_namespace = true
  chart            = "connector"
  repository       = "https://twingate.github.io/helm-charts"
  version          = "0.1.23"

  set {
    name  = "connector.network"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_twingate.secret_string)["twingate1.network"]
  }

  set {
    name  = "connector.accessToken"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_twingate.secret_string)["twingate1.accessToken"]
  }

  set {
    name  = "connector.refreshToken"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_twingate.secret_string)["twingate1.refreshToken"]
  }
}



#########################################################################################################
# Helm - Secondary Connector Twingate
# For redundancy, always deploy a minimum of two Connectors per Remote Network
# https://www.twingate.com/docs/connector-best-practices
# ref: https://artifacthub.io/packages/helm/connector/connector
#########################################################################################################
resource "helm_release" "twingate_secondary" {
  name             = "twingate-speedy-bulldog"
  namespace        = "vpn"
  create_namespace = true
  chart            = "connector"
  repository       = "https://twingate.github.io/helm-charts"
  version          = "0.1.23"

  set {
    name  = "connector.network"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_twingate.secret_string)["twingate2.network"]
  }

  set {
    name  = "connector.accessToken"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_twingate.secret_string)["twingate2.accessToken"]
  }

  set {
    name  = "connector.refreshToken"
    value = jsondecode(data.aws_secretsmanager_secret_version.get_twingate.secret_string)["twingate2.refreshToken"]
  }

  depends_on = [
    helm_release.twingate,
  ]
}
