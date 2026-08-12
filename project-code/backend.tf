terraform {
  backend "s3" {
    bucket       = "ashushre-terraform"
    key          = "ashuedu/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
