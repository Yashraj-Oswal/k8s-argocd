data "kubectl_file_documents" "metallb_namespace" {
    content = file("manifests/metallb/namespace.yaml")
} 

data "kubectl_file_documents" "metallb" {
    content = file("manifests/metallb/metallb.yaml")
}

data "kubectl_file_documents" "configmap" {
    content = file("manifests/metallb/configmap.yaml")
}

resource "kubectl_manifest"  "metallb_namespace" {
  count     = length(data.kubectl_file_documents.metallb_namespace.documents)
  yaml_body = element(data.kubectl_file_documents.metallb_namespace.documents, count.index)
}


resource "kubectl_manifest"  "metallb" {
  depends_on = [
    kubectl_manifest.metallb_namespace
  ]
  count  = length(data.kubectl_file_documents.metallb.documents)
  yaml_body = element(data.kubectl_file_documents.metallb.documents, count.index)
}

resource "kubectl_manifest"  "configmap" {
  depends_on = [
    kubectl_manifest.metallb_namespace,
    kubectl_manifest.metallb
  ]
  count  = length(data.kubectl_file_documents.configmap.documents)
  yaml_body = element(data.kubectl_file_documents.configmap.documents, count.index)
}
