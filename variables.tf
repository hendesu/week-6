variable "resource_group_name_prefix" {
  default       = "staging"
  description   = "Prefix of the resource group name."
}

variable "resource_group_location" {
  default = "eastus"
  description   = "Location of the resource group."
}

variable "machine" {
  default = 3
}

variable "name" {
  default = "postgres-production"
}

variable "pass_db" {
  default = "password123"
  type = string
  sensitive = true
}

variable "pass_app" {
  default = "abc123"
  type = string
  sensitive = true
}

variable "machine_user" {
  default = "tf-app"
  type = string
  sensitive = true
}

variable "db_user" {
  default = "user"
  type = string
  sensitive = true
}

variable "main_user" {
  default = "admin"
  type = string
  sensitive = true
}

variable "main_pass" {
  default = "pass"
  type = string
  sensitive = true
}