variable "azure_subscription_id" {
  type = string
}

variable "azure_client_id" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}

variable "project_name" {
  type    = string
  default = "staticsite"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "location" {
  type    = string
  default = "eastus"
}