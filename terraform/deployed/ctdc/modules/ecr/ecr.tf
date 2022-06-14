# create ecr frontend repository
resource "aws_ecr_repository" "fe_ecr" {
  name = "${lower(var.stack_name)}-${terraform.workspace}-frontend"
  tags = merge(
  {
    "Name" = format("%s-%s-%s",var.stack_name,terraform.workspace,"frontend")
  },
  var.tags,
  )
}

# create ecr backend repository
resource "aws_ecr_repository" "be_ecr" {
  name = "${lower(var.stack_name)}-${terraform.workspace}-backend"
  tags = merge(
  {
    "Name" = format("%s-%s-%s",var.stack_name,terraform.workspace,"backend")
  },
  var.tags,
  )
}

# create ecr files repository
resource "aws_ecr_repository" "files_ecr" {
  name = "${lower(var.stack_name)}-${terraform.workspace}-files"
  tags = merge(
  {
    "Name" = format("%s-%s-%s",var.stack_name,terraform.workspace,"files")
  },
  var.tags,
  )
}