terraform {
  backend "s3" {
    bucket       = var.s3_bucket_name
    key          = "dev/terraform.tfstate"
    region       = var.s3_bucket_region
  }
}
