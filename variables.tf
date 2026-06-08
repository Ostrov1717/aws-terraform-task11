variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_id" {
  description = "Project identifier for tagging resources"
  type        = string
}

variable "vpc" {
  description = "Name of the existing VPC"
  type        = string
}

variable "public_subnet1" {
  description = "Name of the first public subnet"
  type        = string
}

variable "public_subnet2" {
  description = "Name of the second public subnet"
  type        = string
}

variable "ssh_inbound" {
  description = "Name of the security group for SSH access"
  type        = string
}

variable "http_inbound" {
  description = "Name of the security group for HTTP access to EC2"
  type        = string
}

variable "lb_http_inbound" {
  description = "Name of the security group for HTTP access to ALB"
  type        = string
}

variable "load_balancer" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "blue_target_group_name" {
  description = "Name of the Blue target group"
  type        = string
}

variable "green_target_group_name" {
  description = "Name of the Green target group"
  type        = string
}

variable "blue_asg_name" {
  description = "Name of the Blue Auto Scaling Group"
  type        = string
}

variable "green_asg_name" {
  description = "Name of the Green Auto Scaling Group"
  type        = string
}

variable "blue_launch_template_name" {
  description = "Name of the Blue launch template"
  type        = string
}

variable "green_launch_template_name" {
  description = "Name of the Green launch template"
  type        = string
}

variable "blue_weight" {
  description = "Weight of traffic to send to the Blue target group (0-100)"
  type        = number
  default     = 100
}

variable "green_weight" {
  description = "Weight of traffic to send to the Green target group (0-100)"
  type        = number
  default     = 0
}