variable "name" {
    type = string
            description = "GitHub Repository Name."
}

variable "description" {
    type = string
    description = "GitHub Repository Description."
}

variable "visibility" {
    type = string
    description = "Public or Private. Repository visibility parameter."

    validation {
        condition = contains(["public", "private"], var.visibility)
        error_message = "Specify the GitHub repository visibility as 'public' or 'private'."
    }
}

variable "template" {
    type = object({
        owner = string
        repository = string
        include_all_branches = bool
    })
    description = "Github template Repository setting"
    default = null
}
