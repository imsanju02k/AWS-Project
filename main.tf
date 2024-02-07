provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "mybucket1" {
  bucket = "example2k"
}
resource "aws_s3_bucket_ownership_controls" "sanju" {
  bucket = aws_s3_bucket.mybucket1.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

}
resource "aws_s3_bucket" "mybucket2" {
  bucket = "example3k"

  provisioner "local-exec" {
    command = "aws s3 cp s3://example2k/sampletext.txt s3://example3k/"

  }
}

resource "aws_s3_bucket_ownership_controls" "sanjay" {
  bucket = aws_s3_bucket.mybucket2.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

}

resource "aws_s3_bucket_public_access_block" "demo2" {
  bucket                  = aws_s3_bucket.mybucket2.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example4" {
  depends_on = [aws_s3_bucket_ownership_controls.sanjay,
  aws_s3_bucket_public_access_block.demo2]

  bucket = aws_s3_bucket.mybucket2.id
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "my_file" {
  bucket = aws_s3_bucket.mybucket1.id

  for_each     = fileset("myappfiles/", "**/*.*")
  key          = each.value
  source       = "myappfiles/${each.value}"
  content_type = each.value
}

