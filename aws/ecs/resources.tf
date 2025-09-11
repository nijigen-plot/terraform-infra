data "terraform_remote_state" "log_group" {
  backend = "s3"
  workspace = "dev"
  config = {
    bucket = "nijipro-terraform"
    key = "aws/cloudwatch-logs/cloudwatch-logs.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  workspace = "dev"
  config = {
    bucket = "nijipro-terraform"
    key = "aws/iam/iam.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  workspace = "dev"
  config = {
    bucket = "nijipro-terraform"
    key = "aws/vpc/vpc.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "s3" {
  backend = "s3"
  workspace = "dev"
  config = {
    bucket = "nijipro-terraform"
    key = "aws/s3/s3.tfstate"
    region = "ap-northeast-1"
  }
}


module "ecs" {
  source             = "./modules"
  service_name       = "terraform-tutorial"
  env                = terraform.workspace
  task_role_arn      = data.terraform_remote_state.iam.outputs.ecs_task_iam_role_arn
  task_exec_role_arn = data.terraform_remote_state.iam.outputs.ecs_task_exec_iam_role_arn
  log_group_name     = data.terraform_remote_state.log_group.outputs.log_group_name
  alb_vpc_id = data.terraform_remote_state.vpc.outputs.vpd_id
  alb_subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets
  alb_security_group_ids = [
    data.terraform_remote_state.vpc.outputs.security_group
  ]
  alb_log_bucket_name = data.terraform_remote_state.s3.outputs.alb_log_bucket_name
  alb_log_bucket_arn = data.terraform_remote_state.s3.outputs.awlb_log_bucket_arn
  alb_log_bucket_id = data.terraform_remote_state.s3.outputs.awlb_log_bucket_id
  # 同じecsのoutputをmoduleから取ってくる場合は循環参照ではなく依存関係となり実行はできる
  # 内部的に分からんがapplyしたら依存関係の場合は先にリソース作ってから入力変数待ちになってるリソース作って～みたいな感じにするんだろな多分
  ecs_service_cluster_arn = module.ecs.ecs_cluster_arn
  ecs_service_subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  ecs_service_security_groups = [
    # albとecsで同じセキュリティグループを割り当てるのは本来好ましくない
    # 修正するにはVPCのvpc moduleを作成する時にalb,ecs用の2つのセキュリティグループ群が作られるようにしないといけない。
    # moduleを分けるか、resourceでalb,ecs用作るようにするかのどちらか。
    # VPC周りはコンポーネントややこしいからECS用セキュリティグループだけ作ってはいおわり～になるか怪しい まぁ一旦動かす優先にしたいのであとでね。
    data.terraform_remote_state.vpc.outputs.security_group
  ]
  ecs_service_alb_target_group_container_name = "nginx"
}
