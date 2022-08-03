# create ecr frontend repository
resource "aws_ecr_repository" "fe_ecr" {
  count = var.create_ecr_repos ? 1 : 0
  
  name = "${lower(var.stack_name)}-frontend"
  tags = merge(
    {
      "Name" = format("%s-%s-%s", var.stack_name, terraform.workspace, "frontend")
    },
    var.tags,
  )
}

# create ecr backend repository
resource "aws_ecr_repository" "be_ecr" {
  count = var.create_ecr_repos ? 1 : 0
  
  name = "${lower(var.stack_name)}-backend"
  tags = merge(
    {
      "Name" = format("%s-%s-%s", var.stack_name, terraform.workspace, "backend")
    },
    var.tags,
  )
}

# create ecr files repository
resource "aws_ecr_repository" "files_ecr" {
  count = var.create_ecr_repos ? 1 : 0
  
  name = "${lower(var.stack_name)}-files"
  tags = merge(
    {
      "Name" = format("%s-%s-%s", var.stack_name, terraform.workspace, "files")
    },
    var.tags,
  )
}