data "kubectl_file_documents" "namespace" {
    content = file("manifests/argocd/namespace.yaml")
} 

data "kubectl_file_documents" "argocd" {
    content = file("manifests/argocd/install.yaml")
}


resource "kubectl_manifest"  "namespace" {
  depends_on = [
    kubectl_manifest.metallb_namespace,
    kubectl_manifest.metallb,
    kubectl_manifest.configmap
  ]
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

resource "null_resource" "expose_argocdsvc_to_loadbalancer" {
  triggers = {
    key = uuid()
  }
  
  provisioner "local-exec" {
    command = <<EOF
      printf "\nPatching argocd svc named argocd-server into loadbalancer \n"
      kubectl patch svc argocd-server -n argocd -p '{"spec":{"type": "LoadBalancer"}}'
    EOF
  }
  depends_on = [
    kubectl_manifest.argocd
  ]
}



