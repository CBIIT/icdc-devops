resource "aws_ecr_repository" "ecr" {
  for_each = toset(var.app_ecr_registry_names)
  name = "${lower(var.stack_name)}-${each.key}"
  image_tag_mutability = "MUTABLE"
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

resource "aws_ecr_lifecycle_policy" "ecr_life_cycle" {
  repository = aws_ecr_repository.ecr.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 20 images"
      action       = {
        type = "expire"
      }
      selection     = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 15
      }
    }]
  })
}


