terraform {
  required_providers {
    rabbitmq = {
      source  = "cyrilgdn/rabbitmq"
    }
  }
}

provider "rabbitmq" {
    endpoint = "http://${var.host}:15672"
    username = "${var.admin_username}"
    password = "${var.admin_password}"
}

resource "rabbitmq_vhost" "colony_vhost" {
  name = "${var.vhost}"
}

resource "rabbitmq_permissions" "app_user_permissions" {
  user  = "${var.username}"
  vhost = "${rabbitmq_vhost.colony_vhost.name}"

  permissions {
    configure = ".*"
    write     = ".*"
    read      = ".*"
  }
}

resource "rabbitmq_permissions" "admin_user_permissions" {
  user  = "${var.admin_username}"
  vhost = "${rabbitmq_vhost.colony_vhost.name}"

  permissions {
    configure = "(?!x)x"
    write     = "(?!x)x"
    read      = "(?!x)x"
  }
}

resource "rabbitmq_policy" "policy_ha" {
  name  = "ha-all-${var.vhost}"
  vhost = "${rabbitmq_vhost.colony_vhost.name}"

  policy {
    pattern  = "."
    priority = 0
    apply_to = "all"

    definition = {
      ha-mode = "all"
      ha-sync-mode = "automatic"
    }
  }
}
