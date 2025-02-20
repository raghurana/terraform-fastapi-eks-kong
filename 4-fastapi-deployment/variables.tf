variable "aws_access_key" {
  type        = string
  sensitive   = true
  description = "AWS Access Key for authenticating to AWS"
}

variable "aws_secret_key" {
  type        = string
  sensitive   = true
  description = "AWS Secret Key for authenticating to AWS"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Region of the existing EKS cluster"
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the existing EKS cluster"
  sensitive = false
}

variable "aws_user_name" {
  type        = string
  description = "AWS IAM user name for EKS authentication"
  default = "ss-test-cluster"
}

variable "fastapi_image" {
  type        = string
  default     = "1234567890.dkr.ecr.us-east-1.amazonaws.com/fastapi:latest"
  description = "Docker image for the FastAPI application"
}

variable "fastapi_container_port" {
  type        = number
  default     = 80
  description = "Port on which FastAPI container listens"
}

variable "fastapi_service_port" {
  type        = number
  default     = 80
  description = "Kubernetes Service port to map to the container"
}

variable "namespace" {
  type        = string
  default     = "default"
  description = "Kubernetes namespace in which to deploy FastAPI"
}
