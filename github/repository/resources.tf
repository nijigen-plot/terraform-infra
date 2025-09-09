module "server_monitoring_environment" {
  source      = "./modules"
  name        = "server_monitoring_environment"
  description = "Grafana & PrometheusによるRaspberry Pi サーバー監視環境リポジトリ"
  visibility  = "public"
}
