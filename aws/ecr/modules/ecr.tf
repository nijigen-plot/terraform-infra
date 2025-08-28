resource "aws_ecr_repository" "repository" {
    name = "${var.service_name}-${var.env}-${var.role}"
    image_tag_mutability = var.image_tag_mutability
}

resource "aws_ecr_lifecycle_policy" "policy" {
    repository = aws_ecr_repository.repository.name
    # ライフサイクルポリシー。variable repository_lifecycle_policyが空の場合はlifecycle_policy.jsonを読み込む
    policy = var.repository_lifecycle_policy == "" ? file("${path.module}/default_lifecycle_policy.json") : var.repository_lifecycle_policy
}
