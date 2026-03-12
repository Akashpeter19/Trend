variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  default     = "trend-devops"
}

variable "instance_type" {
  description = "EC2 instance type for Jenkins"
  default     = "t3.medium"
}

variable "key_name" {
  description = "AWS key pair name"
  type        = string
}
