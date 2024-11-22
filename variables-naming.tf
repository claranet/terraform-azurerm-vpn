# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name."
  type        = string
  default     = ""
}

# Custom naming override
variable "custom_name" {
  description = "Custom VPN Gateway name, generated if not set."
  type        = string
  default     = ""
}

variable "ipconfig_custom_names" {
  description = "List of VPN GW IP Config resource custom name. One per IP on the gateway."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "public_ip_custom_names" {
  description = "List of VPN GW Public IP resource custom name. One per IP on the gateway."
  type        = list(string)
  default     = []
  nullable    = false
}
