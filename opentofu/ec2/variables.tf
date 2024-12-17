variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "aws_security_group_id" {
  type    = string
  default = ""
}

variable "subnetId" {
  type    = string
  default = ""
}
