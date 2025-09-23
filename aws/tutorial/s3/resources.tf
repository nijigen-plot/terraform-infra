module "alb_log_bucket" {
    source = "./modules"
    service_name = "terraform-tutorial"
    env = terraform.workspace
    prefix = "nijipro"
    s3_bucket_versioning_status = "Disabled"
}
