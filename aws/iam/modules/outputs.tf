output "iam_role_arn" {
    description = "The ARN of the IAM Role"
    value = aws_iam_role.role.arn
}
