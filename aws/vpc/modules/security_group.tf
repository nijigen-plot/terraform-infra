resource "aws_security_group" "security_group" {
    name = "${var.service_name}-${var.env}-security-group"
    vpc_id = aws_vpc.vpc.id
    tags = merge(
        var.security_group_tags,
        {
            Name = "${var.service_name}-${var.env}-security-group"
            Env = var.env
            VpcId = aws_vpc.vpc.id
        }
    )
}

resource "aws_security_group_rule" "ingress_cidr_security_group_rules" {
    for_each = toset(local.ingress_cidr_ports)
    security_group_id = aws_security_group.security_group.id
    type = "ingress"
    protocol = "TCP"
    from_port = each.value
    to_port = each.value
    cidr_blocks = var.security_group_ingress_cidrs
}

resource "aws_security_group_rule" "ingress_sg_security_group_rules" {
    for_each = local.ingress_sg_rules
    type = "ingress"
    security_group_id = aws_security_group.security_group.id
    protocol = "TCP"
    from_port = each.value[0] # 配列の1つ目がport番号なので
    to_port = each.value[0]
    source_security_group_id = each.value[1] # 配列の2つ目がセキュリティグループなので
}

resource "aws_security_group_rule" "security_group_rule_egress" {
    security_group_id = aws_security_group.security_group.id
    type = "egress"
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = var.security_group_egress_cidrs
}

resource "aws_security_group_rule" "security_group_rule_egress_sgs" {
    for_each = toset(var.security_group_egress_sgs)
    security_group_id = aws_security_group.security_group.id
    type = "egress"
    protocol = "-1"
    from_port = 0
    to_port = 0
    source_security_group_id = each.value
}
