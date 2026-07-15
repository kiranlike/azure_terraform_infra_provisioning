# EXEC Access
resource "kubernetes_role" "kube_exec_access_role" {
  metadata {
    name      = "kube-access-exec-role"
    namespace = var.kube_microservices_namespace
    labels = {
      name = "kube-access-exec-role"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "pods/log"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec"]
    verbs      = ["create"]
  }
}

resource "kubernetes_service_account" "kube_exec_access_service_account" {
  for_each = toset(var.kube_exec_access_users)
  metadata {
    name      = "exec-sa-${each.value}"
    namespace = var.kube_microservices_namespace
  }
}

resource "kubernetes_role_binding" "kube_exec_access_role_binding" {
  for_each = toset(var.kube_exec_access_users)
  metadata {
    name      = "exec-rb-${each.value}"
    namespace = var.kube_microservices_namespace
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.kube_exec_access_service_account[each.value].metadata[0].name
    namespace = var.kube_microservices_namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.kube_exec_access_role.metadata[0].name
  }
}

resource "kubernetes_secret" "kube_exec_access_secret" {
  for_each = toset(var.kube_exec_access_users)
  metadata {
    name      = "exec-secret-${each.value}"
    namespace = var.kube_microservices_namespace
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.kube_exec_access_service_account[each.value].metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"
}

data "kubernetes_secret" "kube_exec_access_users" {
  for_each = toset(var.kube_exec_access_users)
  metadata {
    name      = kubernetes_secret.kube_exec_access_secret[each.value].metadata[0].name
    namespace = var.kube_microservices_namespace
  }
}

# READ Access
resource "kubernetes_role" "kube_read_access_role" {
  metadata {
    name      = "kube-access-read-role"
    namespace = var.kube_microservices_namespace
    labels = {
      name = "kube-access-read-role"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "pods/log"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_service_account" "kube_read_access_service_account" {
  for_each = toset(var.kube_read_access_users)
  metadata {
    name      = "read-sa-${each.value}"
    namespace = var.kube_microservices_namespace
  }
}

resource "kubernetes_role_binding" "kube_read_access_role_binding" {
  for_each = toset(var.kube_read_access_users)
  metadata {
    name      = "read-rb-${each.value}"
    namespace = var.kube_microservices_namespace
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.kube_read_access_service_account[each.value].metadata[0].name
    namespace = var.kube_microservices_namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.kube_read_access_role.metadata[0].name
  }
}

resource "kubernetes_secret" "kube_read_access_secret" {
  for_each = toset(var.kube_read_access_users)
  metadata {
    name      = "read-secret-${each.value}"
    namespace = var.kube_microservices_namespace
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.kube_read_access_service_account[each.value].metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"
}

data "kubernetes_secret" "kube_read_access_users" {
  for_each = toset(var.kube_read_access_users)
  metadata {
    name      = kubernetes_secret.kube_read_access_secret[each.value].metadata[0].name
    namespace = var.kube_microservices_namespace
  }
}
