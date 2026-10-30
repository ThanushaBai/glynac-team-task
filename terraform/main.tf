terraform {
  required_providers {
    postgresql = { source = "cyrilgdn/postgresql" }
    nomad      = { source = "hashicorp/nomad" }
    aws        = { source = "hashicorp/aws" }
  }
}

variable "team_name" { 
  type = string 
}

# 1. Postgres Database & User
provider "postgresql" {
  host     = "localhost"
  port     = 5432
  username = "admin"
  password = "password"
  sslmode  = "disable"
}

resource "postgresql_database" "team_db" {
  name = "${var.team_name}-db"
}

resource "postgresql_role" "team_user" {
  name     = "${var.team_name}-user"
  login    = true
  password = "secretpassword"
}

# 2. Nomad Namespace
provider "nomad" {
  address = "http://localhost:4646"
}

resource "nomad_namespace" "team_ns" {
  name        = var.team_name
  description = "Namespace for ${var.team_name}"
}

# 3. S3 Bucket (MinIO)
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "admin"
  secret_key                  = "password"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

  endpoints {
    s3 = "http://localhost:9000"
  }
}

resource "aws_s3_bucket" "team_bucket" {
  bucket = "${var.team_name}-bucket"
}

# 4. Fake VM / Network (Terraform local)
resource "null_resource" "team_vm" {
  triggers = {
    team = var.team_name
  }
}

