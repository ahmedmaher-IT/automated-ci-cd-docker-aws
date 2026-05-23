variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI ID (update per region)"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2 - us-east-1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro" # Free tier eligible
}

variable "key_pair_name" {
  description = "Name of your existing EC2 Key Pair for SSH access"
  type        = string
}
