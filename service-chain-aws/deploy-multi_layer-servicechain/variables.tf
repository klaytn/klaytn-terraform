variable "scn_instance_count" {
  description = "The Number of SCN node"
  default     = 4
}

variable "spn_instance_count" {
  description = "The Number of SPN node"
  default     = 2
}

variable "sen_instance_count" {
  description = "The Number of SEN node"
  default     = 2
}

variable "scn_instance_type" {
  description = "SCN instance node type"
  default     = "m5.xlarge"
}

variable "spn_instance_type" {
  description = "SPN instance node type"
  default     = "m5.xlarge"
}

variable "sen_instance_type" {
  description = "SEN instance node type"
  default     = "m5.xlarge"
}

variable "scn_subnet_ids" {
  description = "A list of subnets to place SCN instance nodes. It could be better set to private subnet if it need to run without public IPs"
  type        = list(string)
}

variable "spn_subnet_ids" {
  description = "A list of subnets to place SPN instance nodes. It usually set to public subnet contrary to scn_subnet_ids"
  type        = list(string)
}

variable "sen_subnet_ids" {
  description = "A list of subnets to place SEN instance nodes. It usually set to public subnet contrary to scn_subnet_ids"
  type        = list(string)
}

variable "en_security_group_id" {
  description = "A EN's security group to anchroing with the ServiceChain"
  type        = string
}



variable "name" {
  description = "Name of every resource's name tag"
  type        = string
  default     = "test"
}

variable "vpc_id" {
  description = "VPC id where the Mainnet, ServiceChain instance nodes will be created"
  type        = string
}

variable "ssh_client_ips" {
  description = "A list of CIDRs to access Mainnet, ServiceChain instance nodes by SSH. It usually set to bastion's IP or Local PC's public IP"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "region" {
  description = "Region where all resources will be created"
  default     = "ap-northeast-2"
  type        = string
}

variable "scn_ebs_volume_size" {
  description = "EBS volume size to attach SCN nodes"
  default     = 50
}

variable "spn_ebs_volume_size" {
  description = "EBS volume size to attach SPN nodes"
  default     = 50
}

variable "sen_ebs_volume_size" {
  description = "EBS volume size to attach SEN nodes"
  default     = 50
}

variable "ssh_pub_key" {
  description = "SSH Public key to access nodes"
  type        = string
}

variable "aws_key_pair_name" {
  description = "A key pair is used to control login access to EC2 instances"
  type        = string
  default     = "ServiceChain-common-test"
}

variable "scn_public_ip" {
  description = "Whether to create a public IP for the SCN instance nodes. They have public ips by default. EN instance nodes have public IPs"
  type        = bool
  default     = true
}

variable "cn_public_ip" {
  description = "Whether to create a public IP for the SCN instance nodes. They have public ips by default. EN instance nodes have public IPs"
  type        = bool
  default     = true
}

variable "security_group" {
  description = "Security group name to attach SCN and EN instance nodes"
  type        = string
  default     = "ServiceChain-common"
}
