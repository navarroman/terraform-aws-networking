variable "vpc_config" {
  description = "Contains the VPC configuration. More specifically the required cidr_block and VPC name."

  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The vpc_config.cidr_block must contain a valid CIDR block."
  }
}
variable "subnet_config" {
  description = <<EOT
 Caeepts a map of subnet configurations. Each subnet configuration should contains the following attributes:
 - cidr_block: The CIDR block for the subnet.
 - public: Whether the subnet is public or not. (default to false)
 - az: The availability zone for the subnet.
EOT 

  type = map(object({
    cidr_block = string
    public     = optional(bool, false)
    az         = string
  }))

  validation {
    condition = alltrue([
      for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "The vpc_config.cidr_block must contain a valid CIDR block."
  }
}