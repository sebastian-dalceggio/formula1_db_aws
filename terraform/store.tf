resource "aws_s3_bucket" "data" {
    bucket = "formula1.sqlite-test"
    force_destroy = true
}