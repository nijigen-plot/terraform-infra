locals {
    # public_subnetsのキーを取得し、そのキー(IP)からAZを取得している
    # {"ap-northeast-1a" = "subnet-xxxxxx", "ap-northeast-1c" = "subnet-yyyyyy"} みたいな中身になる
    from_az_to_public_subnet_id = {
        for cidr in keys(aws_subnet.public_subnets) :
            aws_subnet.public_subnets[cidr].tags["AvailabilityZone"] => aws_subnet.public_subnets[cidr].id
    }
}

# Elastic IP使わないとIP変わっちゃうので使う(固定する)
resource "aws_eip" "eips" {
    for_each = local.from_az_to_public_subnet_id
    # vpc is deprecated Reason: "" とのこと。後で直す
    vpc = true
    tags = {
        Name = "${var.service_name}-${var.env}-${each.key}-eip"
        Env = var.env
        AvailabilityZone = each.key
        Usage = "NAT"
    }
}

resource "aws_nat_gateway" "nat_gateways" {
    for_each = local.from_az_to_public_subnet_id
    allocation_id = aws_eip.eips[each.key].allocation_id
    subnet_id = each.value

    tags = {
        Name = "${var.service_name}-${var.env}-${each.key}-nat-gateway"
        Env = var.env
        AvailabilityZone = each.key
    }
}
