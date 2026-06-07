resource "aws_iam_policy" "this" {
  name        = "cmtr-yz7bruip-iam-policy"
  description = "Custom role with limited permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
        "s3:*"],
        Resource = "*"
      }
    ]
  })
}