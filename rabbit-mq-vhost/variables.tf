variable "host" {
  default     = "infra.sandbox.com"
  description = "RabbitMQ host"
}

variable "username" {
  default     = "colony"
  description = "RabbitMQ user"
}

variable "password" {
  default     = "colony"
  description = "RabbitMQ password"
}

variable "vhost" {
  default     = "colony"
  description = "Colony vhost name"
}
