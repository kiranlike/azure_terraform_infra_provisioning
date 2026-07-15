resource "helm_release" "kubernetes_dashboard" {
  count            = var.create_kubernetes_dashboard ? 1 : 0
  chart            = "kubernetes-dashboard"
  name             = "kubernetes-dashboard"
  namespace        = var.kube_dashboard_namespace
  repository       = "https://kubernetes.github.io/dashboard/"
  version          = "7.5.0"
  create_namespace = true
  cleanup_on_fail  = false
  recreate_pods    = true
  verify           = false
  wait             = true
  timeout          = 1200
  values = [
    file("${path.module}/helm-charts/kubernetes-dashboard-values.yaml")
  ]
  depends_on = [
    azurerm_kubernetes_cluster.kube_cluster,
  ]
}
