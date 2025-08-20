variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-020cba7c55df1f615"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the instance will run"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "SSH key name to connect to EC2"
  type        = string
}

variable "spot_max_price" {
  description = "Max price for spot instance"
  type        = string
  default     = "0.05"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "EC2-for-flaskapp-cicd"
}

variable "volume_size" {
  description = "Root volume size (GB)"
  type        = number
  default     = 8
}

variable "volume_type" {
  description = "Type of root volume"
  type        = string
  default     = "gp3"
}

variable "dockerhub_username" {}

variable "dockerhub_token" {
  sensitive = true
}

variable "availability_zone" {}
