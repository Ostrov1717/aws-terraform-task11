terraform {
  backend "s3" {
    bucket = "cmtr-yz7bruip-backend-new-bucket-1780824830"
    key    = "tf_code.tfstate"
    region = "eu-west-1"
  }
}