# Azure Virtual Network and Subnet Terraform Module

This Terraform module provisions an Azure Virtual Network (VNet) and multiple subnets with various configurations. The module supports the following features:

- Create a Virtual Network (VNet) in a specified Azure region.
- Define multiple subnets with custom configurations, such as address prefixes, service endpoints, private link policies, and delegation.
- Optionally associate the VNet with a DDoS protection plan.
- Output VNet and subnet IDs for further integration.

## Usage

Below is an example of how to use this module in your Terraform configuration:

```hcl
module "azure_vnet" {
  source              = "source  = "thomasvjoseph/vnet/azurerm""

  virtual_network_name = "my-vnet"
  location             = "East US"
  resource_group_name  = "my-resource-group"
  address_space        = ["10.0.0.0/16"]
  dns_servers          = ["10.1.1.1", "10.1.1.2"]

  subnets = {
    public-subnet = {
      name                                      = "public-subnet"
      address_prefix                            = ["10.0.1.0/24"]
      is_private                                = false
      private_endpoint_network_policies         = "Enabled"
      private_link_service_network_policies_enabled = "Enabled"
    }
    private-subnet = {
      name                                      = "private-subnet"
      address_prefix                            = ["10.0.2.0/24"]
      is_private                                = true
      private_endpoint_network_policies         = "Disabled"
      private_link_service_network_policies_enabled = "Disabled"
    }
  }

  subnet_service_endpoints = {
    "public-subnet" = ["Microsoft.Storage"]
  }

  subnet_delegation = {
    "private-subnet" = [{
      name = "private-subnet-delegation"
      service_delegation = {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }]
  }

  ddos_protection_plan_id = null
  tags                    = {
    environment = "production"
  }
}
```

## Module Inputs

| Name                             | Type                           | Default                | Description |
|----------------------------------|--------------------------------|------------------------|-------------|
| `virtual_network_name`           | `string`                       | n/a                    | The name of the virtual network. |
| `location`                       | `string`                       | n/a                    | The Azure region where the resources will be created. |
| `resource_group_name`            | `string`                       | n/a                    | The name of the resource group in which to create the virtual network. |
| `address_space`                  | `list(string)`                 | `["10.0.0.0/16"]`       | The address space that is used by the virtual network. |
| `dns_servers`                    | `list(string)`                 | `[]`                   | A list of DNS servers to be used with the virtual network. |
| `ddos_protection_plan_id`        | `string`                       | `null`                 | The ID of the DDoS Protection Plan to associate with the virtual network. |
| `subnets`                        | `map(object)`                  | n/a                    | A map of subnet configurations. |
| `subnet_service_endpoints`       | `map(list(string))`            | `{}`                   | A map of service endpoints to associate with each subnet. |
| `subnet_delegation`              | `map(list(object))`            | `{}`                   | A map of subnet delegation configurations. |
| `tags`                           | `map(string)`                  | `{}`                   | A map of tags to assign to the virtual network resource. |

## Module Outputs

| Name                  | Description |
|-----------------------|-------------|
| `virtual_network_id`   | The ID of the created virtual network. |
| `subnet_ids`           | A map of subnet names to subnet IDs. |
| `public_subnet_id`     | A map of public subnet names to subnet IDs where `is_private` is `false`. |

## Example Subnet Configuration

You can configure subnets with custom attributes such as:

- `address_prefix`: The IP address range for the subnet.
- `is_private`: A boolean value indicating whether the subnet is private.
- `private_endpoint_network_policies`: The private endpoint network policies for the subnet.
- `private_link_service_network_policies_enabled`: Enables or disables private link service network policies.
- `subnet_delegation`: Delegates a subnet to a specific service like `Microsoft.Web/serverFarms`.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for more details.

## Contributing

Feel free to open an issue or submit a pull request to improve the module.