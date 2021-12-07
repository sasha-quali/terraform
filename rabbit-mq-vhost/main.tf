terraform {
  required_providers {
    rabbitmq = {
      source  = "cyrilgdn/rabbitmq"
    }
  }
}

provider "rabbitmq" {
    endpoint = "http://${var.host}:15672"
    username = "${var.username}"
    password = "${var.password}"
}

resource "rabbitmq_vhost" "colony_vhost" {
  name = "${var.vhost}"
}
