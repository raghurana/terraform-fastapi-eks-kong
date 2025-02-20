variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

# --------------------------------------------------------------
# EKS Cluster


variable "name" {
  description = "Name of the cluster"
  type        = string
  default     = "ss-test-cluster"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# --------------------------------------------------------------
# VPC

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.123.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "CIDR block for the public subnets"
  type        = list(string)
  default     = ["10.123.1.0/24", "10.123.2.0/24"]
}

variable "private_subnets" {
  description = "CIDR block for the private subnets"
  type        = list(string)
  default     = ["10.123.3.0/24", "10.123.4.0/24"]
}

variable "intra_subnets" {
  description = "CIDR block for the intra subnets"
  type        = list(string)
  default     = ["10.123.5.0/24", "10.123.6.0/24"]
}

variable "fargate_namespace" {
  description = "Kubernetes namespace for Fargate workloads"
  type        = string
  default     = "fargate-apps"
}