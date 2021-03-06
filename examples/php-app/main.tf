terraform {
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

# Create a VPC
module "vpc" {
  source = "../../modules/vpc"

  name       = "beankstalk-vpc"
  cidr_block = "10.0.0.0/16"
}

# Create subnets
module "subnet" {
  source = "../../modules/subnet"

  name                = "beankstalk-sn"
  vpc_id              = module.vpc.id
  cidr_block          = "10.0.X.0/24"
  associate_public_ip = true
}

# Create the bucket to store the code and upload app code
module "s3" {
  source = "../../modules/s3"

  bucket_name = "elasticbeanstalk-${var.app_name}-code-bucket"
  object_key  = "appsrc_${var.app_version}.zip"
  object_path = "${path.module}/appsrc_${var.app_version}.zip"
}

# Create beanstalk app
module "beanstalk" {
  source = "../../modules/beanstalk"

  count = var.num

  app_name                   = var.num > 1 ? "${var.app_name}-${count.index}" : var.app_name
  app_version                = var.app_version
  vpc_id                     = module.vpc.id
  subnet_ids                 = join(",", module.subnet.subnet_ids)
  source_code_bucket_id      = module.s3.bucket_id
  source_code_bucket_obj_key = module.s3.object_key
}
