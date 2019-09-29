module "cloudfront" {
  source = "./cloudfront"
  domain_name = "${module.s3.s3_bucket_regional_domain_name}"
}
