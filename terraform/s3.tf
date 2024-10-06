data "aws_ssm_parameter" "resume_bucket_name" {
  name = var.bucket_name_ssm_param
}

resource "aws_s3_bucket" "resume_bucket" {
  bucket = data.aws_ssm_parameter.resume_bucket_name.value

  tags = var.cloud_resume_tag
}

resource "aws_s3_bucket_policy" "resume_bucket_policy" {
  bucket = aws_s3_bucket.resume_bucket.id
  policy = templatefile("bucket-policy.tftpl", { bucket_name = aws_s3_bucket.resume_bucket.id, distribution_arn = aws_cloudfront_distribution.cloud_resume_distribution.arn })
}