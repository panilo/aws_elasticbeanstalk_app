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

`terraform apply -var="app_name=example-beanstalk-php-app"`
