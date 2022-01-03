# AWS Elastic Beanstalk Primer

This repository contains an introduction project to AWS Elastic Beanstalk. The goal of this project is to illustrate how to spin up a simple PHP
application using AWS Beanstalk.

## About AWS Beanstalk

AWS Beanstalk is a service for deploying and scaling web applications developed in many popular languages like NodeJS, Python, PHP, .NET, etc..., on a server like Tomcat, Apache, IIS, Node. AWS Beanstalk automatically handles the deployment of your application creating the underlying infrastructure: capacity provision, load balancing, autoscaling, and application health.

You retain control of the resources created by AWS Beanstalk and pay just for the used resources.

### Features

- Fast / Easy way to deploy web apps (3-tiers applications) on AWS
- Automatically scales your app up and down
- You can configure your runtime environment
- You can retain control over the created resources or let Beanstalk manage them for you
- Beanstalk automatically manages platform updates (Java, PHP, Node, etc...)

## Run terraform

Move to the `./examples/example-beanstalk-php-app` directory and run

`terraform apply -var="app_name=example-php-app" -var="app_version=v1"`

## Create multiple environment 

You can create multiple environment by passing the num variable

`terraform apply -var="app_name=example-php-app" -var="app_version=v1" -var="num=3"`

## Update your app version

This primer is using the following update strategy: `rolling update type time bach size 25%`.

You can configure a different update strategy by changing the appropriate attributes in `./modules/beanstalk/main.tf` resource `aws_elastic_beanstalk_environment`. The meta-argument controlling the update strategy is the `setting` argument, in particular the one having as `namespace`

- `aws:autoscaling:updatepolicy:rollingupdate`
- `aws:elasticbeanstalk:command`

To see a comprehensive list of settings and their values visit AWS doc at this [link](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalingupdatepolicyrollingupdate).

In this example you need to apply the configuration at the folder `./examples/example-beanstalk-php-app/release-version-2` to upload new version of your PHP example app. In this example we create a new state for the updated app version, you can also use the same state by applying the config at `./examples/example-beanstalk-php-app` defining a different `app_version` variable.

> This `different state` approach has been taken because it allows us to define and keep different app versions rather than replacing the existing resource with a new one.

`terraform apply -var="app_name=example-php-app" -var="app_version=v2"`

Finally to deploy your app to the environment

`aws --region $(terraform output --raw region) elasticbeanstalk update-environment --environment-name $(terraform output --raw environment_name) --version-label $(terraform output --raw app_version)`

## Update multiple environment 

If you created more than one environment you need to pass the num variable 

`terraform apply -var="app_name=example-php-app" -var="app_version=v2" -var="num=2"`