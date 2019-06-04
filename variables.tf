
variable "name" {
  description = "The friendly name for the SNS platform application"
  type        = string
}

variable "platform" {
  type        = string
  description = "The platform that the app is registered with. See Platform for supported platforms like 'APNS' 'GCM'"
  default     = ""
}

variable "key" {
  type        = string
  default     = ""
  description = "Application Platform credential. See Credential for type of credential required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources"

}

variable "certificate" {
  type        = string
  default     = null
  description = "application Platform principal. See Principal for type of principal required for platform. The value of this attribute when stored into the Terraform state is only a hash of the real value, so therefore it is not practical to use this as an attribute for other resources"

}