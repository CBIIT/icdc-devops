
module "alb" {
  source               = "./modules/alb"
  app                  = var.app
  vpc_id               = var.vpc_id
  certificate_arn      = var.alb_certificate_arn
  subnets              = var.public_subnet_ids
  tags                 = var.tags
  create_alb_s3_bucket = var.create_alb_s3_bucket
  domain_url           = var.domain_url
  alb_s3_bucket_name   = var.alb_s3_bucket_name
  alb_s3_prefix        = var.alb_s3_prefix
}
