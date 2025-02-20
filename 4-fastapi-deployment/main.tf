terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.25.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "this" {
  # The existing EKS cluster name, coming from a variable
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "default" {
  # Must match the same cluster name
  name = var.eks_cluster_name
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
  }
}



resource "kubernetes_config_map_v1_data" "aws_auth" {

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.aws_user_name}"
        username = var.aws_user_name
        groups   = ["system:masters"]
      }
    ])
  }

  force = true
}

resource "kubernetes_deployment" "fastapi" {
  metadata {
    name      = "fastapi-deployment"
    namespace = var.namespace
    labels = {
      app = "fastapi"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "fastapi"
      }
    }
    template {
      metadata {
        labels = {
          app = "fastapi"
        }
      }
      spec {
        container {
          name  = "fastapi"
          image = var.fastapi_image
          port {
            container_port = var.fastapi_container_port
          }
          # If you need environment variables, mount secrets, etc. define them here

        }
      }
    }
  }
}

resource "kubernetes_service" "fastapi" {
  metadata {
    name      = "fastapi-service"
    namespace = var.namespace
    labels = {
      app = "fastapi"
    }
  }
  spec {
    selector = {
      app = "fastapi"
    }
    port {
      name        = "http"
      port        = var.fastapi_service_port
      target_port = var.fastapi_container_port
    }
  }
}
