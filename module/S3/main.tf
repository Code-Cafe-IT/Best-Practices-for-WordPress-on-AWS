resource "aws_s3_bucket" "example" {
  bucket = "test-tv-020-05-2024"

  tags = {
    Name        = "${var.project_name}-s3"
  }
}