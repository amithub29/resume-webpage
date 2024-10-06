variable "bucket_name_ssm_param" {
  default = "/resume_website/prod/s3/front_end/bucket_name"
}

variable "cloud_resume_tag" {
  default = { Project = "Cloud Resume Challenge" }
}

variable "default_root_object" {
  default = "index.html"
}

variable "alternate_domain_alias" {
  default = ["resume.amitmehta.cloud"]
}

variable "acm_certificate_arn" {
  default = "arn:aws:acm:us-east-1:891377355669:certificate/c350e8f9-1074-41b2-a35e-81ca10b6d7e4"
}