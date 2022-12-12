module "alb" {
  source = "../../modules/networks/alb"
  stack_name = var.program
  alb_name = var.alb_name
  frontend_app_name = var.app
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  certificate_arn = data.aws_acm_certificate.certificate.arn
  subnets =data.terraform_remote_state.network.outputs.public_subnets_ids
  tags = var.tags
  env = var.env
}
