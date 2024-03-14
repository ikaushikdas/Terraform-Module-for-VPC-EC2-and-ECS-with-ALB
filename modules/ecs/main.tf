# main.tf

# Define provider
provider "aws" {
  region = var.region # Choose your preferred AWS region
}

# # Create ALB
# resource "aws_lb" "my_lb" {
#   name               = "ui-alb"
#   internal           = false
#   load_balancer_type = "application"
#   subnets            = var.subnet_id_value # Replace with your subnet IDs
#   security_groups    = [var.sg_value]  # Replace with your security group IDs
# }
# # Create ALB listener
# resource "aws_lb_listener" "my_listener" {
#   load_balancer_arn = aws_lb.my_lb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.my_target_group.arn
#   }
# }
# # Create ALB target group
# resource "aws_lb_target_group" "my_target_group" {
#   name        = "ui-task"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id  # Replace with your VPC ID
#   target_type = "ip"
# }

# Define IAM role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach the necessary policies to the ECS task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Define IAM role for ECS task
resource "aws_iam_role" "ecs_task_role" {
  name               = "ecs-task-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Create ECS cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = var.ecs_cluster_name_value

  tags = {
    Name = var.ecs_cluster_name_value
  }
}

# Define container definitions for the task
data "aws_ecr_image" "my_image" {
  repository_name = var.ecr_repository_name_value # Replace with your ECR image name
  most_recent = true 
}

# Attach additional policies to the ECS task role if needed

resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = var.ecs_task_family_name_value
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = var.vpc_name # Use awsvpc network mode for Fargate tasks
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = jsonencode([
    {
      "name": "ui-container",
      "image": "${data.aws_ecr_image.my_image.image_uri}",
      "cpu": 256,
      "memory": 512,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ]
    }
  ])
  runtime_platform {
      operating_system_family = "LINUX"
      cpu_architecture        = "ARM64"
   }
}

# Create ECS service
resource "aws_ecs_service" "my_service" {
  name            = var.ecs_service_name_value
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"  # or "FARGATE" depending on your setup

  # VPC configuration
  network_configuration {
    security_groups = [var.sg_value]  # Add your security group IDs
    subnets         = var.subnet_id_value  # Add your subnet IDs
    assign_public_ip = true  # Set to true if you want to assign public IPs to tasks
  }
   load_balancer {
    target_group_arn = var.alb_arn_value
    container_name   = var.ecs_container_name_value
    container_port   = 80
  }
  
}


