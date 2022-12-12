resource "aws_iam_policy" "ssm-policy" {
  name   = "${var.program}-${var.app}-frontend-${var.env}-ssm-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.ssm-policy-document.json
}
data "aws_iam_policy_document" "ssm-policy-document" {
  statement {
    sid = "10"

    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData",
      "ds:CreateComputer",
      "ds:DescribeDirectories",
      "ec2:DescribeInstanceStatus",
      "logs:*",
      "ssm:*",
      "ec2messages:*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:CreateServiceLinkedRole"
    ]

    resources = [
      "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*"
    ]

    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values = [
        "ssm.amazonaws.com"
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:DeleteServiceLinkedRole",
      "iam:GetServiceLinkedRoleDeletionStatus"
    ]

    resources = [
      "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*",
    ]
  }
}



resource "aws_iam_role" "ec2-instance-role" {
  name               = "${var.program}-${var.app}-frontend-${var.env}-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2-instance-policy.json
}

data "aws_iam_policy_document" "ec2-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role_policy_attachment" "ec2-instance-role-attachment" {
  role       = aws_iam_role.ec2-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2-instance-profile" {
  name  = "${var.program}-${var.app}-frontend-${var.env}-ecs-instance-profile"
  path  = "/"
  role = aws_iam_role.ec2-instance-role.id

}
