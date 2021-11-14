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
  source = "./modules/vpc"

  name       = "beankstalk-vpc"
  cidr_block = "10.0.0.0/16"
}

# Create subnets
module "subnet" {
  source = "./modules/subnet"

  name                = "beankstalk-sn"
  vpc_id              = module.vpc.id
  cidr_block          = "10.0.X.0/24"
  associate_public_ip = true
}

# Create the bucket to store the code
resource "aws_s3_bucket" "myapp_source_code" {
  bucket = "${var.app_name}-code-bucket"
}

# Upload app code
resource "aws_s3_bucket_object" "myapp_source_code" {
  bucket = aws_s3_bucket.myapp_source_code.id
  key    = "appsrc_${var.app_version}.zip"
  source = "${path.module}/appsrc_${var.app_version}.zip"
}

# Create beanstalk app
module "beanstalk" {
  source = "./modules/beanstalk"

  app_name                   = var.app_name
  app_version                = var.app_version
  vpc_id                     = module.vpc.id
  subnet_ids                 = join(",", module.subnet.subnet_ids)
  source_code_bucket_id      = aws_s3_bucket.myapp_source_code.id
  source_code_bucket_obj_key = aws_s3_bucket_object.myapp_source_code.key
}
