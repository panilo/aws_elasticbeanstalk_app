# Create an IAM Instance profile for EC2 instances, they will run the beankstalk app
resource "aws_iam_role" "myapp_iam_role" {
  name = "${var.app_name}-iam-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  POLICY
}

resource "aws_iam_role_policy_attachment" "myapp_iam_role_aws_beanstalk_webtier" {
  role       = aws_iam_role.myapp_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "myapp_iam_role_aws_beanstalk_multicontainer_docker" {
  role       = aws_iam_role.myapp_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role_policy_attachment" "myapp_iam_role_aws_beanstalk_workertier" {
  role       = aws_iam_role.myapp_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_instance_profile" "myapp_iam_instance_profile" {
  name = "${var.app_name}-instance-profile"
  role = aws_iam_role.myapp_iam_role.name
}

# Create Beanstalk app
resource "aws_elastic_beanstalk_application" "myapp" {
  name        = var.app_name
  description = "App created by TF in AWS Beanstalk"
}

# App code version, your code uploaded is now associated with an app version
resource "aws_elastic_beanstalk_application_version" "myapp_code_version" {
  name        = "${var.app_name}-code-version"
  application = aws_elastic_beanstalk_application.myapp.name
  bucket      = var.source_code_bucket_id
  key         = var.source_code_bucket_obj_key
}

# App environment, configure the runtime environment
resource "aws_elastic_beanstalk_environment" "myapp_environment" {
  name                = "${var.app_name}-environment"
  application         = aws_elastic_beanstalk_application.myapp.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.7 running PHP 7.4"
  version_label       = aws_elastic_beanstalk_application_version.myapp_code_version.name

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = var.subnet_ids
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "2"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "4"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.myapp_iam_instance_profile.name
  }
}
