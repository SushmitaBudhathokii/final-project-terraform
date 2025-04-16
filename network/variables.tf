variable "env" {
  type        = string
  default     = "staging"
}

variable "default_tags" {
  type    = map(any)
  default = {
    "owner" = "sbudhathoki7-vlpalicpic",
    "env"   = "staging"
  }
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "public_cidr_blocks" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
}

variable "private_cidr_blocks" {
  type    = list(string)
  default = ["10.1.5.0/24", "10.1.6.0/24"]
}
