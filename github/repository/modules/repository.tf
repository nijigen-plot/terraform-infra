resource "github_repository" "repository" {
    name = var.name
    description = var.description
    visibility = var.visibility
    auto_init = true
    dynamic "template" {
        for_each = var.template != null ? [var.template] : []
        content {
            owner = template.value.owner
            repository = template.value.repository
            include_all_branches = template.value.include_all_branches
        }
    }
}
