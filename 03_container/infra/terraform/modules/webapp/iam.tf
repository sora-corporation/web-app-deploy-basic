# for AppRunner
data "aws_iam_policy_document" "apprunner_service" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["tasks.apprunner.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "apprunner" {
  name               = "apprunner-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.apprunner_service.json
}

# resource "aws_iam_policy" "apprunner" {
#   name = "apprunner-policy-${var.project}"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {},
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "apprunner" {
#   role       = aws_iam_role.apprunner.name
#   policy_arn = aws_iam_policy.apprunner.arn
# }

# for AppRunner Builder
data "aws_iam_policy_document" "apprunner_builder" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["build.apprunner.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "apprunner_builder" {
  name               = "apprunner-builder-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.apprunner_builder.json
}

resource "aws_iam_policy" "apprunner_builder" {
  name = "apprunner-builder-policy-${var.project}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:*",
          "apprunner:*",
          "secretsmanager:*",
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_builder" {
  role       = aws_iam_role.apprunner_builder.name
  policy_arn = aws_iam_policy.apprunner_builder.arn
}