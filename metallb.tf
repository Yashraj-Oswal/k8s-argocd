data "kubectl_file_documents" "metallb-namespace" {
    content = file("manifests/metallb/namespace.yaml")
} 

data "kubectl_file_documents" "metallb" {
    content = file("manifests/metallb/metallb.yaml")
}

data "kubectl_file_documents" "configmap" {
    content = file("manifests/metallb/configmap.yaml")
}

resource "kubectl_manifest"  "metallb-namespace" {
  count     = length(data.kubectl_file_documents.metallb-namespace.documents)
  yaml_body = element(data.kubectl_file_documents.metallb-namespace.documents, count.index)
  override_namespace = "metallb"
}


resource "kubectl_manifest"  "metallb" {
  depends_on = [
    kubectl_manifest.namespace
  ]
  count  = length(data.kubectl_file_documents.metallb.documents)
  yaml_body = element(data.kubectl_file_documents.metallb.documents, count.index)
  override_namespace = "metallb"
}

resource "kubectl_manifest"  "configmap" {
  depends_on = [
    kubectl_manifest.namespace,
    kubectl_manifest.metallb
  ]
  count  = length(data.kubectl_file_documents.configmap.documents)
  yaml_body = element(data.kubectl_file_documents.configmap.documents, count.index)
  override_namespace = "metallb"
}
