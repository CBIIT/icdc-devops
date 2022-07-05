# create ecr repository
resource "aws_ecr_repository" "backstage_ecr" {
  name = "${lower(var.app)}-${terraform.workspace}"
  tags = merge(
    {
      "Name" = format("%s-%s", var.app, terraform.workspace)
    },
    var.tags,
  )
}