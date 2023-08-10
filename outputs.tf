output "vm_id-1" {
  description = "VM-ID"
  value = azurerm_linux_virtual_machine.vm1.id
}

output "publicIP-1" {
  description = "Public IP"
  value = azurerm_public_ip.pip_1.ip_address
}

  output "private_ip" {
  description = "Private IP"
  value = azurerm_network_interface.vnic1.private_ip_address
}