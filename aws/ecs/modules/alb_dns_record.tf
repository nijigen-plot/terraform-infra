resource "aws_route53_record" "record" {
    zone_id = data.aws_route53_zone.zone.id
    name = local.dns_a_record
    type = "A"
    alias {
        # aws_lb.alb_dns_nameとその下は同じterraform内のoutputの自己参照してる。
        # これは循環じゃなくて依存関係だからOK
        name = aws_lb.alb.dns_name
        zone_id = aws_lb.alb.zone_id
        evaluate_target_health = false
    }
}
