variable "location" {
  default = "East US"
}

variable "vm_count" {
  default = 3
}

variable "vm_size" {
  default = "Standard_B1s" # Free-tier eligible
}

variable "admin_username" {
  default = "ctfadmin"
}

variable "admin_password" {
  description = "Password for VMs"
}
