terraform {
  required_providers {
    nomad      = { source = "hashicorp/nomad" }
    aws        = { source = "hashicorp/aws" }
  }
}

variable "team_prefix" { 
  type = string 
}

variable "team_count" {
  type = number
  default = 1
}

# 2. Nomad Namespace
provider "nomad" {
  address = "http://localhost:4646"
}

resource "nomad_namespace" "team_ns" {
  count        = var.team_count
  name = "${var.team_prefix}-${count.index + 1}"
  description = "Namespace for ${var.team_prefix}-${count.index + 1}"
}

# 3. S3 Bucket (Silo)
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
  count = var.team_count
  bucket = "${var.team_prefix}-${count.index + 1}-bucket"
}

# 4. Fake VM / Network (Terraform local)
resource "null_resource" "team_vm" {
  count = var.team_count
  triggers = {
    team = "${var.team_prefix}-${count.index + 1}"
  }
}

