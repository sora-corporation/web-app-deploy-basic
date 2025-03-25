data "aws_iam_policy_document" "ec2_service" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "webapp" {
  name               = "webapp-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_service.json
}

data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.webapp.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

resource "aws_iam_instance_profile" "webapp" {
  name = "webapp-profile"
  role = aws_iam_role.webapp.name
}
