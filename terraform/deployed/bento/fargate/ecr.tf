resource "aws_ecr_repository" "ecr" {
  name = "${lower(var.stack_name)}-${terraform.workspace}-ecr"
  tags = merge(
  {
    "Name" = format("%s-%s-%s",var.stack_name,terraform.workspace,"ecr-registry")
  },
  var.tags,
  )
}

resource "aws_ecr_repository_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr.name
  policy     = data.aws_iam_policy_document.ecr_policy_doc.json
}



