# Klaytn service-chain nodes aws module

A terraform module to create a Klaytn service chain network including SCN nodes and main chain EN nodes. It help you to build infrustcture on AWS. After create instance nodes with this module, you may can install KSCN, KEN with [klaytn-ansible](https://github.com/klaytn/klaytn-ansible) project under Klaytn organization. For more details regarding Klaytn service chains, please refer to [Klaytn Docs](https://docs.klaytn.com/node/service-chain).


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

Or simply edit [terraform.tfvars](https://github.com/klaytn/klaytn-terraform/blob/master/serivce-chain-aws/terraform.tfvars) and fill each elements. Then run `terraform init / plan / apply` to create resources in AWS.


## with VPC module example

This module not create network layers such as VPC/Subnet. It could be done with [terraform-aws-vpc module](https://github.com/terraform-aws-modules/terraform-aws-vpc.git) which provide on terraform-aws-modules organization. A example is contained in the [examples/with_vpc](https://github.com/klaytn/klaytn-terraform/tree/master/serivce-chain-aws/examples/with_vpc) directory.


## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 2.43 |

It creates SCN, EN instance nodes with [CentOS AMI](https://aws.amazon.com/marketplace/pp/Centosorg-CentOS-7-x8664-with-Updates-HVM/B00O7WM7QW#pdp-usage) in AWS marketplace. You need to accept the terms and subscribe before running terraform apply.


## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.43 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_key\_pair\_name | A key pair is used to control login access to EC2 instances | `string` | `"ServiceChain-common"` | no |
| en\_ebs\_volume\_size | EBS volume size to attach EN nodes. default volume indicate minimum size in klaytn docs | `number` | `500` | no |
| en\_instance\_count | The Number of EN node | `number` | `1` | no |
| en\_instance\_type | EN instance node type | `string` | `"m5.2xlarge"` | no |
| en\_subnet\_ids | A list of subnets to place EN instance nodes. It usually set to public subnet contrary to scn\_subnet\_ids | `list(string)` | n/a | yes |
| name | Name of every resource's name tag | `string` | `"test"` | no |
| region | Region where all resources will be created | `string` | `"ap-northeast-2"` | no |
| scn\_ebs\_volume\_size | EBS volume size to attach SCN nodes | `number` | `50` | no |
| scn\_instance\_count | The Number of SCN node | `number` | `4` | no |
| scn\_instance\_type | SCN instance node type | `string` | `"m5.xlarge"` | no |
| scn\_public\_ip | Whether to create a public IP for the SCN instance nodes. They have public ips by default. EN instance nodes have public IPs | `bool` | `true` | no |
| scn\_subnet\_ids | A list of subnets to place SCN instance nodes. It could be better set to private subnet if it need to run without public IPs | `list(string)` | n/a | yes |
| security\_group | Security group name to attach SCN and EN instance nodes | `string` | `"ServiceChain-common"` | no |
| ssh\_client\_ips | A list of CIDRs to access SCN, EN instance nodes by SSH | `list(string)` | n/a | yes |
| ssh\_pub\_key | SSH Public key to access SCN instance nodes, EN instance nodes | `string` | n/a | yes |
| tags | A map of tags to add to all resources | `map` | `{}` | no |
| vpc\_id | VPC id where the SCN, EN instance nodes will be created | `string` | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| en\_ip\_addr | EN instance nodes' private ip. Helpful when creating an inventory file to use with Ansible. |
| scn\_ip\_addr | SCN instance nodes' private ip. Helpful when creating an inventory file to use with Ansible. |
