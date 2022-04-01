# ecr policy
resource "aws_ecr_repository_policy" "fe_ecr_policy" {
  repository = aws_ecr_repository.fe_ecr.name
  policy     = data.aws_iam_policy_document.ecr_policy_doc.json
}

resource "aws_ecr_repository_policy" "be_ecr_policy" {
  repository = aws_ecr_repository.be_ecr.name
  policy     = data.aws_iam_policy_document.ecr_policy_doc.json
}

data "aws_iam_policy_document" "ecr_policy_doc" {

  statement {
    sid    = "ElasticContainerRegistryPushAndPull"
    effect = "Allow"

    principals {
      identifiers = ["${data.aws_caller_identity.caller.account_id}"]
      type        = "AWS"
    }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
  }
}

