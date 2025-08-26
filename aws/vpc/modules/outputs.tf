output "vpc_id" {
    description = "VPC ID"
    value = aws_vpc.vpc.id
}

output "service_name" {
    description = "VPC Name"
    value = aws_vpc.vpc.tags["Name"]
}
