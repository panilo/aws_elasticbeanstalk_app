variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "tags" {
  type = map(string)
  default = {
    "project"     = "tf-refresher"
    "aws-service" = "beanstalk"
  }
}

variable "app_name" {
  type = string
}

variable "app_version" {
  type = string
}

variable "num" {
  type    = string
  default = ""
}
