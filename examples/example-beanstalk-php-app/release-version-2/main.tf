terraform {
  backend "local" {
    path = "./terraform_app_version_2.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
}

locals {
  app_version_name = "${var.app_name}-${var.app_version}"
}

# Get the S3 bucket where app is store
module "s3" {
  source = "../../../modules/s3"

  bucket_name = "${var.app_name}-code-bucket"
  object_key  = "appsrc_${var.app_version}.zip"
  object_path = "${path.module}/appsrc_${var.app_version}.zip"

  create_bucket = false
}

# Get the beanstalk app
data "aws_elastic_beanstalk_application" "myapp" {
  name = var.app_name
}

# Add a new app version
resource "aws_elastic_beanstalk_application_version" "myapp_version" {
  name        = local.app_version_name
  application = data.aws_elastic_beanstalk_application.myapp.name
  bucket      = module.s3.bucket_id
  key         = module.s3.object_key
}


output "environment_name" {
  value = "${var.app_name}-environment"
}

output "app_version" {
  value = local.app_version_name
}

output "region" {
  value = var.region
}
