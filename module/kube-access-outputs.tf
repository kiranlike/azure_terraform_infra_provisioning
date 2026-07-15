output "kube" {
  value = {
    exec_access = [
      for username in var.kube_exec_access_users : {
        host     = "${var.kube_dns_prefix}.${var.dns_zone_name}"
        username = username
        token    = data.kubernetes_secret.kube_exec_access_users[username].data["token"]
      }
    ]
    read_access = [
      for username in var.kube_read_access_users : {
        host     = "${var.kube_dns_prefix}.${var.dns_zone_name}"
        username = username
        token    = data.kubernetes_secret.kube_read_access_users[username].data["token"]
      }
    ]
  }
  sensitive = true
}
