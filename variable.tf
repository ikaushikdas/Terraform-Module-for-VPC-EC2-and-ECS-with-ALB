# Global
variable "mod_region" {
  default = "ap-south-1"
}

# For VPC Module
variable "mod_zone" {
  default = ["ap-south-1a", "ap-south-1b"]
}
variable "mod_cidr" {
  default = "10.0.0.0/16"
}
variable "mod_key_name" {
  default = "aws-key"
}
variable "mod_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
#--- End of VPC----

# For EC2 Module
variable "mod_ami" {
  default = "ami-0a1b648e2cd533174"
}
variable "mod_instance_type" {
  default = "t2.micro"
}
#--- End of EC2----

# For ECS Module
variable "ecs_cluster_name" {
  default = "ui-cluster"
}
variable "ecr_repository_name" {
  default = "ui-task"
}
variable "ecs_task_family_name" {
  default = "ui-task"
}
variable "ecs_service_name" {
  default = "ui-service"
}
variable "ecs_container_name" {
  default = "ui-container"
}
#--- End of ECS----