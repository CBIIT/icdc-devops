
module "alb" {
  source = "./modules/alb"
  stack_name = var.stack_name
  vpc_id = var.vpc_id
  certificate_arn = var.alb_certificate_arn
  subnets = var.public_subnet_ids
  tags = var.tags
  create_alb_s3_bucket = var.create_alb_s3_bucket
}
