# terraform-klaytn-service-chain-nodes

A terraform module to create klaytn service chain node with Azure Virtual network and VMs

## Usage 
```
Chage the values of Resource group Name, Prefix and Location at terraform.tfvar

  name_prifix               = "service-chain"
  azure_rg_name             = "service"
  azure_location            = "uswest"

Change Virtual network values at input.tf of Azure_virtual_network

Network Security Group is associated to Subnet
```

## Requirements

| Name | Version |
|------|---------|
| azurerm | =1.28.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | =1.28.0 |
| http | n/a |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_location | Azure location | `string` | n/a | yes |
| azure\_rg\_name | azure resource group name | `string` | n/a | yes |
| name\_prifix | resource prifix | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| en\_private\_ip | EN instance nodes' private ip. It might help create inventory file when it comes to use ansible |
| en\_public\_ip | EN instance nodes' public ip. It might help create inventory file when it comes to use ansible |
| scn\_private\_ip | SCN instance nodes' private ip. It might help create inventory file when it comes to use ansible |

## Module Azure Virtual Network
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_location | Azure location | `string` | n/a | yes |
| azure\_resource\_group\_name | Resource group name | `string` | n/a | yes |
| azure\_vnet\_cidr | Subnet ID | `string` | `"10.0.0.0/16"` | no |
| en\_subnet\_cidr | virtual machine size | `string` | `"10.0.0.0/24"` | no |
| scn\_subnet\_cidr | Subnet ID | `string` | `"10.0.1.0/24"` | no |
| vm\_prefix | Name prifix | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| azure\_vnet\_cidr | n/a |
| azure\_vnet\_id | n/a |
| azure\_vnet\_name | n/a |
| en\_subnet\_cidr | n/a |
| en\_subnet\_id | n/a |
| scn\_subnet\_cidr | n/a |
| scn\_subnet\_id | n/a |

## Module en_vm
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_location | Azure location | `string` | n/a | yes |
| azure\_resource\_group\_name | Resource group name | `string` | n/a | yes |
| azure\_subnet\_id | Subnet ID | `string` | n/a | yes |
| azure\_virtual\_machine\_size | virtual machine size | `string` | `"Standard_D8S V3"` | no |
| azure\_vmadmin\_account | account | `string` | `"vmadmin"` | no |
| en\_data\_disk\_size\_gb | Storage data disk size | `string` | `"512"` | no |
| en\_vm\_count | n/a | `number` | `1` | no |
| ssh\_key | SSH public Key | `string` | `"~/.ssh/id_rsa.pub"` | no |
| tags | A map of tags to add to all resources | `map` | `{}` | no |
| vm\_prefix | Name prifix | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| en\_private\_ip | EN instance nodes' private ip. It might help create inventory file when it comes to use ansible |
| en\_public\_ip | EN instance nodes' public ip. It might help create inventory file when it comes to use ansible |
| scn\_private\_ip | SCN instance nodes' private ip. It might help create inventory file when it comes to use ansible |
| en\_vm\_id | n/a |

## Module scn_vm
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_location | Azure location | `string` | n/a | yes |
| azure\_resource\_group\_name | Resource group name | `string` | n/a | yes |
| azure\_subnet\_id | Subnet ID | `string` | n/a | yes |
| azure\_virtual\_machine\_size | virtual machine size | `string` | `"Standard_D4S V3"` | no |
| azure\_vmadmin\_account | account | `string` | `"vmadmin"` | no |
| scn\_data\_disk\_size\_gb | Storage data disk size | `string` | `"64"` | no |
| scn\_vm\_count | n/a | `number` | `4` | no |
| ssh\_key | SSH public Key | `string` | `"~/.ssh/id_rsa.pub"` | no |
| tags | A map of tags to add to all resources | `map` | `{}` | no |
| vm\_prefix | Name prifix | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| en\_private\_ip | EN instance nodes' private ip. It might help create inventory file when it comes to use ansible |
| scn\_vm\_id | n/a |

## Contributing
Report issues/questions/feature requests on in the [issues](https://github.com/klaytn/terraform-service-chain/issues/new) section

## License
MIT Licensed