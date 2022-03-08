provider "kubernetes" {
  config_path = pathexpand(var.kind_config-path)
}


provider "kubectl" {}

provider "http" {}
