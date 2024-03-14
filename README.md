# Terraform Modules for AWS Infrastructure

This repository contains Terraform modules for provisioning AWS infrastructure components such as VPCs, EC2 instances, and ECS clusters.

## Prerequisites

Before you begin, ensure you have the following:

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- AWS credentials configured on your machine or environment.
- Access to an AWS account.

## Backend

Configure Terraform backend to use the S3 bucket for state management

## state locking

Optional: Use DynamoDB for state locking

## Modules

### S3 Module

The S3 module provisions an S3 bucket with customizable configurations.

#### Inputs

- `region`: AWS region for the S3 bucket.
- `bucket_name_value`: Name of the S3 bucket.

#### Outputs

- `bucket name` : To print the bucket name

### VPC Module

The VPC module provisions a Virtual Private Cloud (VPC) in AWS with public and private subnets across multiple availability zones.

#### Inputs

- `cidr_value`: CIDR block for the VPC.
- `zone_value`: List of availability zones to distribute subnets.
- `key_name_value`: Name of the SSH key pair to be used.
- `key_path_value`: Path to the SSH private key file.
- `region`: AWS region for the VPC.

#### Outputs

- `public_subnet_id`: IDs of the public subnets.
- `private_subnet_id`: IDs of the private subnets.
- `aws_vpc_name`: Name of the VPC.
- `vpc_id`: ID of the VPC.
- `aws_key_pair`: Name of the key pair created.

### EC2 Module

The EC2 module provisions EC2 instances in the VPC created by the VPC module.

#### Inputs

- `region`: AWS region for the EC2 instances.
- `ami_value`: ID of the AMI to use for the EC2 instances.
- `instance_type_value`: Instance type for the EC2 instances.
- `subnet_id_value`: ID of the subnet where the EC2 instances will be deployed.
- `key_name_value`: Name of the SSH key pair to be used.
- `sg_value`: ID of the security group to associate with the EC2 instances.

#### Outputs
- `Public Ip`: Public Ip of the instance.

### ALB Module

The ALB module provisions an Application Load Balancer (ALB) in the VPC.

#### Inputs

- `region`: AWS region for the ALB.
- `subnet_id_value`: ID of the subnet where the ALB will be deployed.
- `sg_value`: ID of the security group to associate with the ALB.
- `vpc_id`: ID of the VPC.

#### Outputs
- `load_balancer_endpoint`: Endpoint of the Application Load Balancer.

### ECS Module

The ECS module provisions ECS clusters and associated resources, including an Application Load Balancer (ALB).

#### Inputs

- `region`: AWS region for the ECS resources.
- `subnet_id_value`: ID of the subnet where ECS tasks will be deployed.
- `sg_value`: ID of the security group to associate with the ECS resources.
- `vpc_name`: Name of the VPC.
- `vpc_id`: ID of the VPC.
- `ecs_cluster_name_value`: Name of the ECS cluster.
- `ecr_repository_name_value`: Name of the ECR repository.
- `ecs_task_family_name_value`: Name of the ECS task family.
- `ecs_service_name_value`: Name of the ECS service.
- `ecs_container_name_value`: Name of the ECS container.


## Usage

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/ikaushikdas/Terraform-Module-for-VPC-EC2-and-ECS-with-ALB.git
   Update the root variables as per your requirements!
   terraform init
   terraform plan
   terraform apply -auto-approve
