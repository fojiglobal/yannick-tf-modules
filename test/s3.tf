resource "aws_s3_bucket" "example" {
  bucket = "yannick-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}