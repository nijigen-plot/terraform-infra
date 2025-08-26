`$ terraform apply -var-file=env/dev.tfvars`みたいな指定も「できる」という話であって、現状のコードではworkspaceをdev,stg,prodで変更すればそれに応じてEnvのタグの値が変わるってだけ
