# Outputの役割として
# 1. ここで作ったモジュールを親モジュールも参照できるようにする
# 2. terraform applyした後の結果表示
output "vpc_id" {
    description = "VPC ID"
    value = aws_vpc.vpc.id
}

output "vpc_name" {
    description = "VPC Name"
    value = aws_vpc.vpc.tags["Name"]
}

output "public_subnets" {
    description = "Public Subnets"
    value = {for subnet in aws_subnet.public_subnets : subnet.availability_zone => subnet.id}
}

output "private_subnets" {
    description = "private Subnets"
    value = {for subnet in aws_subnet.private_subnets : subnet.availability_zone => subnet.id}
}

output "public_route_tables" {
    description = "Public Route Tables"
    value = {for route_table in aws_route_table.public_route_tables : route_table.tags["AvailabilityZone"] => route_table.id}
}

output "private_route_tables" {
    description = "private Route Tables"
    value = {for route_table in aws_route_table.private_route_tables : route_table.tags["AvailabilityZone"] => route_table.id}
}
