variable "env" {
  description = "Environment type (dev or prod)"
  type        = string
  default     = "staging"
}

# Default tags
variable "default_tags" {
  default = { "owner" = "sbudhathoki7-vlpalicpic", "env" = "staging" }
  type    = map(any)
}


# Variable for CIDR block for VPC
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"
}

# Provision public subnets in custom VPC
variable "public_cidr_blocks" {
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_cidr_blocks" {
  default     = ["10.1.5.0/24", "10.1.6.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}


