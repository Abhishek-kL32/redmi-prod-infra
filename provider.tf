provider "aws" {
  region = "ap-south-1"
  default_tags {
    tags = {
      "project" = var.project_name
      "env"     = var.project_env
    }
  }
}

