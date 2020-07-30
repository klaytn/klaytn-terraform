# terraform-klaytn-service-chain-nodes

A terraform to create klaytn service chain node with Azure Virtual network and VMs

## Usage (The location of Resource group and Virtual network must be same)
```
Chage the values of terraform.tfvar

resource_group_name   = "klaytn"     
en_subnet_name        = "en-subnet"           
scn_subnet_name       = "scn-subnet"          
vnet_name             = "klaytn-vnet"     
vm_prefix             = "service-chain"     
admin_username        = "vmadmin"                          
ssh_key               = "~/.ssh/id_rsa.pub"

Network Security Group is associated to Network Interface

## Requirements

| Name | Version |
|------|---------|
| azurerm | =1.28.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |
| http | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_username | n/a | `any` | n/a | yes |
| en\_data\_disk\_size\_gb | Storage data disk size | `string` | `"512"` | no |
| en\_subnet\_name | n/a | `any` | n/a | yes |
| en\_vm\_count | n/a | `number` | `1` | no |
| en\_vm\_size | Specifies the size of the virtual machine. | `string` | `"Standard_D8S_V3"` | no |
| resource\_group\_name | n/a | `any` | n/a | yes |
| scn\_data\_disk\_size\_gb | Storage data disk size | `string` | `"64"` | no |
| scn\_subnet\_name | n/a | `any` | n/a | yes |
| scn\_vm\_count | n/a | `number` | `4` | no |
| scn\_vm\_size | Specifies the size of the virtual machine. | `string` | `"Standard_D4S_V3"` | no |
| ssh\_key | n/a | `any` | n/a | yes |
| tags |A map of tags to add to all resources | `map` | `{}` | no |
| vm\_hostname\_prefix | n/a | `any` | n/a | yes |
| vnet\_name | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| en\_private\_ip | EN instance nodes' private ip. It might help create inventory file when it comes to use ansible |
| en\_public\_ip | EN instance nodes' public ip. It might help create inventory file when it comes to use ansible |
| scn\_private\_ip | SCN instance nodes' private ip. It might help create inventory file when it comes to use ansible |


## Contributing
Report issues/questions/feature requests on in the [issues](https://github.com/klaytn/terraform-service-chain/issues/new) section

## License
MIT Licensed