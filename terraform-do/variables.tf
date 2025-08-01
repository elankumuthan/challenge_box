variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "region" {
  description = "DigitalOcean region for droplets"
  default     = "sgp1" # Singapore - change if needed
}

variable "vm_count" {
  description = "Number of droplets (1 per player)"
  default     = 3
}

variable "droplet_size" {
  description = "Droplet size"
  default     = "s-1vcpu-1gb"
}

variable "ssh_key_fingerprint" {
  description = "d0:f1:8f:41:eb:f5:07:bd:e1:9a:ba:af:68:8a:b1:b7"
  type        = string
}
