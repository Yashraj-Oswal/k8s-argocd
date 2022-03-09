resource "null_resource" "installing_ingress_controller" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\nWaiting for the nginx ingress controller...\n"
      helm upgrade --install ingress-nginx ingress-nginx \
      --repo https://kubernetes.github.io/ingress-nginx \
      --namespace ingress-nginx --create-namespace
    EOF
  }
  depends_on = [
    kubectl_manifest.namespace,
    kubectl_manifest.argocd,
    null_resource.expose_argocdsvc_to_loadbalancer
  ]

}

data "kubectl_file_documents"  "create_ingress" {
  content = file("manifests/argocd/ingress_expose.yaml")
}


resource "kubectl_manifest" "create_ingress" {
  depends_on = [
    null_resource.installing_ingress_controller
  ]
  count     = length(data.kubectl_file_documents.create_ingress.documents)
  yaml_body = element(data.kubectl_file_documents.create_ingress.documents, count.index)
  
}
