# Variable definitions
variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network."
}

variable "location" {
  type        = string
  description = "The Azure region where the resources will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network."
}

variable "address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "The address space that is used by the virtual network."
}

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "A list of DNS servers to be used with the virtual network."
}

variable "ddos_protection_plan_id" {
  type        = string
  default     = null
  description = "The ID of the DDoS Protection Plan to associate with the virtual network."
}

variable "subnets" {
  description = "A map of subnet configurations."
  type = map(object({
    name           = string
    address_prefix = list(string)
    is_private     = bool
    private_endpoint_network_policies = optional(string)
    private_link_service_network_policies_enabled = optional(string)
  }))
}

variable "subnet_service_endpoints" {
  type        = map(list(string))
  default     = {}
  description = "A map of service endpoints to associate with each subnet."
}

variable "subnet_delegation" {
  type = map(list(object({
    name               = string
    service_delegation = object({
      name    = string
      actions = optional(list(string))
    })
  })))
  default     = {}
  description = "A map of subnet delegation configurations."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to the virtual network resource."
}