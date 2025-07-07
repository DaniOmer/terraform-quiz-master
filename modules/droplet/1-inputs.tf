variable "name" {
  description = "The name of the droplet."
  type        = string
}

variable "image" {
  description = "The droplet image."
  type        = string
  default     = "ubuntu-22-04-x64"
}

variable "size" {
  description = "The size of the droplet."
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "region" {
  description = "The region where the droplet will be deployed."
  type        = string
  default     = "fra1"
}

variable "vpc_uid" {
  description = "The ID of the VPC where the Droplet will be located."
  type        = string
}

variable "backups" {
  description = "Boolean controlling if backups are made."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A list of the tags to be applied to this Droplet"
  type        = list(string)
  default     = []
}

variable "ssh_key_name" {
  description = "The name of the SSH key to be used to connect to the Droplet"
  type        = string
}

variable "public_key_path" {
  description = "The path to the public key to be used to connect to the Droplet"
  type        = string
}