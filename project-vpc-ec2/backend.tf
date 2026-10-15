terraform {
  backend "s3" {
    bucket       = var.s3_bucket_name
    key          = "dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
