# Variable for EC2 key pair name
variable "key_name" {
  type    = string
  default = "acs730-final-proj"
}

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