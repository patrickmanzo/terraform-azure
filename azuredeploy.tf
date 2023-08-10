# Create Resource Group

resource "azurerm_resource_group" "resource_group" {
  name          = var.resource_group_name
  location      = var.resource_group_region 
  tags = {
    Environment = "prod"
  }
}

# Create Virtual Network - VNET
resource "azurerm_virtual_network" "vnet_1" {
  name                 = var.vnet_name_1
  address_space        = var.vnet_1_address_space
  dns_servers          = var.dns_servers
  location             = azurerm_resource_group.resource_group.location
  resource_group_name  = azurerm_resource_group.resource_group.name
  tags = {
    Environment        = "prod"
  }
}

# Create Subnet
resource "azurerm_subnet" "subnet_1" {
  name                 = var.subnet_name_1
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet_1.name
  address_prefixes     = var.subnet_1_prefixes
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                 = var.network_security_group_name_1
  location             = azurerm_resource_group.resource_group.location
  resource_group_name  = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment                = "prod"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg" {
  network_interface_id      = azurerm_network_interface.vnic1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a public IP for the VM
resource "azurerm_public_ip" "pip_1" {
  name                = "${var.vm_1}-Public-IP"
  resource_group_name = azurerm_resource_group.resource_group.name
  depends_on          = [var.resource_group_name]
  location            = azurerm_resource_group.resource_group.location
  allocation_method   = "Static"
  tags = {
    Environment       = "prod"
  }
}

# Create VNIC
resource "azurerm_network_interface" "vnic1" {
  name                = "${var.vm_1}-NIC"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "default"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_1.id
    # private_ip_address          = var.private_ip_address
  }
}

# Create Linux VM
resource "azurerm_linux_virtual_machine" "vm1" {
  # count = ""
  name                          = var.vm_1
  resource_group_name           = azurerm_resource_group.resource_group.name
  location                      = azurerm_resource_group.resource_group.location
  size                          = "Standard_F2"
  admin_username                = "azureuser"
  # secure_boot_enabled         = "true"
  network_interface_ids         = [
    azurerm_network_interface.vnic1.id,

  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "${var.vm_1}-OS-Disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "40"
  }

  source_image_reference {
    publisher      = "Canonical"
    offer          = "UbuntuServer"
    sku            = "18.04-LTS"
    version        = "latest"
  }
    tags = {
      Environment  = "prod"
  }
}