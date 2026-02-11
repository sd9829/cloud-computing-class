terraform {
  backend "s3" {
    bucket = "soms-terraform-211-activity"
    key    = "github-actions-activity/terraform.tfstate"
    region = "us-east-1"
  }
}
