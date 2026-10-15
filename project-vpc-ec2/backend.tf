terraform {
  backend "s3" {
    bucket       = "terraform-s3-test-susanta-project"
    key          = "dev/terraform.tfstate"
    region       = "ap-south-1"
  }
}
