provider "kubernetes" {
  config_path = pathexpand(var.kind_config-path)
}


provider "kubectl" {}

provider "http" {}

provider "null" {}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kind_config-path)
  }

}
