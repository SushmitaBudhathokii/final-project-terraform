# Define variables for the prod network module, which are passed to the networkmodule.

variable "env" {
  description = "Environment type"
  type        = string
  default     = "prod"
}

# Default tags
variable "default_tags" {
  default     = { "owner" = "vlpalicpic" }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}