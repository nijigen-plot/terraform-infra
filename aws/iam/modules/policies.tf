resource "aws_iam_role_policy_attachment" "attachments" {
    for_each = toset(var.managed_iam_policy_arns)
    role = aws_iam_role.role.id
    policy_arn = each.key
}

locals {
    inline_policy_documents = {
        ECRLogin = data.aws_iam_policy_document.ecr_login.json
        PullContainerImage = data.aws_iam_policy_document.docker_image_pull.json
        DeployECSService = data.aws_iam_policy_document.deploy_service.json
    }
}

resource "aws_iam_role_policy" "inline_policies" {
    for_each = local.inline_policy_documents
    role = aws_iam_role.role.id
    name = each.key
    policy = each.value
}
