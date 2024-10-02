# S3

data "aws_ssm_parameter" "resume_bucket_name" {
  name = "/resume_website/prod/s3/front_end/bucket_name"
}

resource "aws_s3_bucket" "resume_bucket" {
  bucket = data.aws_ssm_parameter.resume_bucket_name.value

  tags = {
    Project        = "Cloud Resume Challenge"
  }
}

resource "aws_s3_bucket_policy" "resume_bucket_policy" {
  bucket = data.aws_ssm_parameter.resume_bucket_name.value
  policy = templatefile("bucket-policy.tpl", { bucket_name = data.aws_ssm_parameter.resume_bucket_name.value})
}

