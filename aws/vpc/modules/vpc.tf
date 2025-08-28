resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block

    # mergeは後から定義されたキーのバリューで上書きされるため、必須であるものを後ろに定義する
    tags = merge(
        var.vpc_additional_tags,
        {
            Name = var.service_name
            Env = var.env
        }
    )
}
