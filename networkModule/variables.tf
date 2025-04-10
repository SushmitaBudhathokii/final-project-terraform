# networkmodule/variables.tf
# Define variables for network module configuration, such as CIDR blocks for VPCs and subnets.

# Variable for CIDR block for VPC Dev.
variable "vpc_cidr_dev" {
  description = "CIDR block for VPC Dev"
  type        = string
  default     = "10.1.0.0/16"
}

# Variable for CIDR block for VPC Prod.
variable "vpc_cidr_prod" {
  description = "CIDR block for VPC Prod"
  type        = string
  default     = "10.10.0.0/16"
}

# Provision public subnets in custom VPC - dev
variable "public_cidr_blocks" {
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC - dev
variable "private_cidr_blocks_dev" {
  default     = ["10.1.3.0/24", "10.1.4.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC - prod
variable "private_cidr_blocks_prod" {
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}


# Default tags
variable "default_tags" {
  default     = {"owner" = "vlpalicpic" }
  type        = map(any)
}

variable "env" {
  description = "Environment type (dev or prod)"
  type        = string
}