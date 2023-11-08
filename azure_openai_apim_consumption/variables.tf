variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

variable "location" {
  type    = string
  default = "Japan East"
}

variable "apim_publisher_name" {
  type = string
}

variable "apim_publisher_email" {
  type = string

  validation {
    condition     = can(regex("^[^@]+@[^@]+$", var.apim_publisher_email))
    error_message = "Invalid email address"
  }
}

variable "health_alert_user_name" {
  type = string
}

variable "health_alert_user_email_address" {
  type = string

  validation {
    condition     = can(regex("^[^@]+@[^@]+$", var.health_alert_user_email_address))
    error_message = "Invalid email address"
  }
}

