variable "ami-id" {

  type        = string
  description = "default ami will be Amazon Linux"
}

variable "instance_type" {

  type        = string
  description = "Free tyre instance type"
}

variable "project_name" {

  type        = string
  description = "Name of Project"
}

variable "project_env" {

  type        = string
  description = "Project Environment"
}

variable "owner" {

  type        = string
  description = "Project Environment"
}
variable "hostname" {

  type        = string
  description = "hostname of the frontend"
}

variable "hosted_zone_name" {

  type        = string
  description = "main domain name"
}

