### Roles

resource "aws_iam_role" "ec2" {
  name               = "${var.naming.name}-ec2"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  tags = var.naming.tags
}

### Policies

resource "aws_iam_policy" "s3_access" {
  name        = "${var.naming.name}-s3_access"
  description = "Allow access to s3 bucket"
  policy      = data.aws_iam_policy_document.s3_access.json
}

### Policy attachments

resource "aws_iam_role_policy_attachment" "ec2" {
  policy_arn = aws_iam_policy.s3_access.arn
  role       = aws_iam_role.ec2.name
}