# Project Variables

variable "resource_group_region" {
    type = string
    description = "The location for the deployment"
    default = "West Europe"
}

variable "resource_group_name" {
    type = string
    description = "Resorce Group name in Azure"
    default = "InfraRG"
}

variable "vnet_name_1" {
    type = string
    description = "VNET name in Azure"
    default = "VNET-1"
}

variable "vnet_1_address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.0.0.0/16"]
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  default     = []
}

variable "subnet_name_1" {
    type = string
    description = "Subnet  name in Azure"
    default = "SUBNET-1"
}

variable "subnet_1_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "network_security_group_name_1" {
    type = string
    description = "Network Security Group name in Azure"
    default = "NSG-1"
}

variable "pip_1" {
    type = string
    description = "Name for the public IP"
    default = "PublicIP-1"
}

variable "vm_1" {
    type = string
    description = "Linux VM name in Azure"
    default = "VM-1"
}

variable "vnic_1" {
    type = string
    description = "NIC name in Azure"
    default = "VNIC-1"
}