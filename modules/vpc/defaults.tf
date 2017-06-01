provider "aws" {
  region = "${var.region}"
}

terraform {
  required_version = ">= 0.9.4"
}
