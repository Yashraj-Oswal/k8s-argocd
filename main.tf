data "kubectl_file_documents" "namespace" {
    content = file("../kubernetes-argocd/manifests/argocd/namespace.yaml")
} 

data "kubectl_file_documents" "argocd" {
    content = file("../kubernetes-argocd/manifests/argocd/install.yaml")
}


resource "kubectl_manifest"  "namespace" {
  count     = length(data.kubectl_file_documents.namespace.documents)
  yaml_body = element(data.kubectl_file_documents.namespace.documents, count.index)
  override_namespace = "argocd"
}


resource "kubectl_manifest"  "argocd" {
  depends_on = [
    kubectl_manifest.namespace
  ]
  count  = length(data.kubectl_file_documents.argocd.documents)
  yaml_body = element(data.kubectl_file_documents.argocd.documents, count.index)
  override_namespace = "argocd"
}


