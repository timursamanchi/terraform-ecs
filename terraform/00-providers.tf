# providers file

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # latest 5.x
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0" # latest 4.x
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.2" # latest 2.x
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9" # latest 0.x
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "tls" {}
provider "local" {}
provider "time" {}
provider "random" {}
provider "null" {}

provider "aws" {
  region = var.aws_region
}