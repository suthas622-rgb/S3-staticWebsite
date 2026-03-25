resource "random_id" "bucket_suffix" {
  byte_length = 5

}

resource "aws_s3_bucket" "staticmasu" {
  bucket = "staticmasu-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket_public_access_block" "staticweb" {
  bucket                  = aws_s3_bucket.staticmasu.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}
resource "aws_s3_bucket_policy" "masupolicy" {
  bucket = aws_s3_bucket.staticmasu.id
  policy = jsonencode({
    version = "2012-10-17"
    Statement = [
      {
        Sid       = "GetObj"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        resource  = "${aws_s3_bucket.staticmasu.arn}/*"
      }

    ]
  })
}

resource "aws_s3_bucket_website_configuration" "staticmasu" {
  bucket = aws_s3_bucket.staticmasu.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}