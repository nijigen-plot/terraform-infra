output task_definition_arn {
    value = module.ecs.task_definition_arn
}

output task_definition_arn_without_revision {
    value = module.ecs.task_definition_arn_without_revision
}

output ecs_service_arn {
    value = module.ecs.ecs_service_arn
}
