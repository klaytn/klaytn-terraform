# Klaytn service-chain nodes aws module

A terraform module to create a Klaytn service chain network and a private main chain. It helps you to build infrustcture on AWS. After create instance nodes with this module, you may can install and configure Klaytn nodes with [klaytn-ansible](https://github.com/klaytn/klaytn-ansible) project under Klaytn organization. For more details regarding Klaytn service chains, please refer to [Klaytn Docs](https://docs.klaytn.com/node/service-chain).


## Usage

You may use the module with the following configuration (for example):
```
module "klaytn-service-chain" {
    source = "github.com/klaytn/klaytn-terraform/serivce-chain-aws"

    name           = "service-chain-test"
    region         = "ap-northeast-2"
    scn_subnet_ids = ["subnet-abcde0123456", "subnet-bcdef012345"]
    en_subnet_ids  = ["subnet-cdefg0123456"]
    vpc_id         = "vpc-abcdef12345"
    ssh_client_ips = ["132.122.144.33/32"]
    ssh_pub_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSUGPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XAt3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/EnmZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbxNrRFi9wrf+M7Q== mypublicsshkey@mylaptop.local"
}
```

Or simply edit [terraform.tfvars](https://github.com/klaytn/klaytn-terraform/blob/master/serivce-chain-aws/deploy-L1-L2/terraform.tfvars) and fill each element. Then run `terraform init / plan / apply` to create resources in AWS.

## with VPC module example

This module does not create network resourcse such as the VPC/subnet. This could be done with [terraform-aws-vpc module](https://github.com/terraform-aws-modules/terraform-aws-vpc.git) which is provided in the terraform-aws-modules organization. A example is contained in the [examples/with_vpc](https://github.com/klaytn/klaytn-terraform/tree/master/serivce-chain-aws/examples/with_vpc) directory.


## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 2.43 |


## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.43 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_key\_pair\_name | A key pair is used to control login access to EC2 instances | `string` | `"ServiceChain-common"` | no |
| cn\_ebs\_volume\_size | EBS volume size to attach CN nodes. default volume indicate minimum size in klaytn docs | `number` | `500` | no |
| pn\_ebs\_volume\_size | EBS volume size to attach PN nodes. default volume indicate minimum size in klaytn docs | `number` | `500` | no |
| en\_ebs\_volume\_size | EBS volume size to attach EN nodes. default volume indicate minimum size in klaytn docs | `number` | `500` | no |
| cn\_instance\_count | The Number of CN node | `number` | `4` | no |
| pn\_instance\_count | The Number of PN node | `number` | `2` | no |
| en\_instance\_count | The Number of EN node | `number` | `1` | no |
| cn\_instance\_type | CN instance node type | `string` | `"m5.2xlarge"` | no |
| pn\_instance\_type | PN instance node type | `string` | `"m5.2xlarge"` | no |
| en\_instance\_type | EN instance node type | `string` | `"m5.2xlarge"` | no |
| cn\_subnet\_ids | A list of subnets to place CN instance nodes. It could be better set to private subnet if it need to run without public IPs | `list(string)` | n/a | yes |
| pn\_subnet\_ids | A list of subnets to place PN instance nodes. It usually set to public subnet contrary to cn\_subnet\_ids | `list(string)` | n/a | yes |
| en\_subnet\_ids | A list of subnets to place EN instance nodes. It usually set to public subnet contrary to cn\_subnet\_ids | `list(string)` | n/a | yes |
| name | Name of every resource's name tag | `string` | `"test"` | no |
| region | Region where all resources will be created | `string` | `"ap-northeast-2"` | no |
| scn\_ebs\_volume\_size | EBS volume size to attach SCN nodes | `number` | `50` | no |
| spn\_ebs\_volume\_size | EBS volume size to attach SPN nodes | `number` | `50` | no |
| sen\_ebs\_volume\_size | EBS volume size to attach SEN nodes | `number` | `50` | no |
| scn\_instance\_count | The Number of SCN node | `number` | `4` | no |
| spn\_instance\_count | The Number of SPN node | `number` | `2` | no |
| sen\_instance\_count | The Number of SEN node | `number` | `2` | no |
| scn\_instance\_type | SCN instance node type | `string` | `"m5.xlarge"` | no |
| spn\_instance\_type | SPN instance node type | `string` | `"m5.xlarge"` | no |
| sen\_instance\_type | SEN instance node type | `string` | `"m5.xlarge"` | no |
| scn\_public\_ip | Whether to create a public IP for the SCN instance nodes. They have public ips by default. EN instance nodes have public IPs | `bool` | `true` | no |
| scn\_subnet\_ids | A list of subnets to place SCN instance nodes. It could be better set to private subnet if it need to run without public IPs | `list(string)` | n/a | yes |
| spn\_subnet\_ids | A list of subnets to place SPN instance nodes. It should be set to public subnet because it need to run with public IPs | `list(string)` | n/a | yes |
| sen\_subnet\_ids | A list of subnets to place SEN instance nodes. It should be set to public subnet because it need to run with public IPs | `list(string)` | n/a | yes |
| security\_group | Security group name to attach SCN and EN instance nodes | `string` | `"ServiceChain-common"` | no |
| ssh\_client\_ips | A list of CIDRs to access SCN, EN instance nodes by SSH | `list(string)` | n/a | yes |
| ssh\_pub\_key | SSH Public key to access SCN instance nodes, EN instance nodes | `string` | n/a | yes |
| tags | A map of tags to add to all resources | `map` | `{}` | no |
| vpc\_id | VPC id where the SCN, EN instance nodes will be created | `string` | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| cn\_private\_ip\_addr | CN instance nodes' private ip. Helpful when creating an inventory file to use with Ansible. |
| cn\_public\_ip\_addr | CN instance nodes' public ip. Helpful when creating an inventory file to use with Ansible. |
| pn\_public\_ip\_addr | PN instance nodes' public ip. Helpful when creating an inventory file to use with Ansible. |
| en\_public\_ip\_addr | EN instance nodes' public ip. Helpful when creating an inventory file to use with Ansible. |
| scn\_private\_ip\_addr | SCN instance nodes' private ip. Helpful when creating an inventory file to use with Ansible. |
| scn\_public\_ip\_addr | SCN instance nodes' public ip. Helpful when creating an inventory file to use with Ansible. |
| spn\_public\_ip\_addr | SPN instance nodes' public ip. Helpful when creating an inventory file to use with Ansible. |
| sen\_public\_ip\_addr | SEN instance nodes' public ip. Helpful when creating an inventory file to use with Ansible. |
