variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
    description = "VPC CIDR block"

    validation {
        condition = can(regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}", var.vpc_cidr_block))
        error_message = "Specify VPC CIDR block with the CIDR format."
    }
}

variable "service_name" {
    type = string
    description = "Service name"
}

variable "env" {
    type = string
    description = "Environment Identifier"

    validation {
        condition = contains(["dev", "stg", "prod"], var.env)
        error_message = "Specify the environment identifier as 'dev', 'stg', or 'prod'."
    }
}

variable "vpc_additional_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the VPC"
}

variable "subnet_cidrs" {
    description = "List of subnet CIDR blocks"
    type = object({
        public = list(string)
        private = list(string)
    })

    # パブリックサブネットのIPが全て正規表現に合致している場合に通る
    validation {
        condition = length(setintersection([
            for cidr in var.subnet_cidrs.public : (can(
                regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}", cidr)
            ) ? cidr : null)
        ],
        var.subnet_cidrs.public)) == length(var.subnet_cidrs.public)
        error_message = "Specify public subnet CIDR blocks with the CIDR format."
    }

    validation {
        condition = length(setintersection([
            for cidr in var.subnet_cidrs.private : (can(
                regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}", cidr)
            ) ? cidr : null)
        ],
        var.subnet_cidrs.private)) == length(var.subnet_cidrs.private)
        error_message = "Specify private subnet CIDR blocks with the CIDR format."
    }

    # 可用性の為public,privateそれぞれ2つ以上必要とする
    validation {
        condition = length(var.subnet_cidrs.public) >= 2
        error_message = "For availability, set more than two public subnet CIDR blocks."
    }

    validation {
        condition = length(var.subnet_cidrs.private) >= 2
        error_message = "For availability, set more than two private subnet CIDR blocks."
    }

    # public,privateの冗長度を合わせる
    validation {
        condition = length(var.subnet_cidrs.public) == length(var.subnet_cidrs.private)
        error_message = "Set the same number of public and private subnet CIDR blocks for availability."
    }
}

variable "subnet_additional_tags" {
    type = map(string)
    default = {}
    # 特定のキー名は予約語として使用禁止にする
    validation {
        condition = length(setintersection(keys(var.subnet_additional_tags),
        ["Name", "Env", "AvailabilityZone", "Scope"])) == 0
        error_message = "Key names, Name and Env, AvailabilityZone, Scope are reserved. Not allowed to use them."
    }
    description = "Additional tags for the Subnets"
}

variable "igw_additional_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the Internet Gateway"
    validation {
        condition = length(setintersection(keys(var.igw_additional_tags),
        ["Name", "Env", "VpcId"])) == 0
        error_message = "Key names, Name and Env, VpcId are reserved. Not allowed to use them."
    }
}

# var.security_group_ingress_portsはlist(number)なのでlist(string)に変換。for_eachはlist(number)に対応していない
# toset(list(string))とすることでfor_eachが可能
# https://discuss.hashicorp.com/t/for-each-with-list-number/6596/2
locals {
    ingress_cidr_ports = [ for v in var.security_group_ingress_ports : tostring(v)]
}

# setproductは総当たりする関数。
# join(",", v) => vとしているので、"var.security_group_ingress_ports,var.security_group_ingress_sgs"キーに[var.security_group_ingress_ports, var.security_group_ingress_sgs]が入る。
# で配列の要素総当たり
locals {
    ingress_sg_rules = { for v in setproduct(var.security_group_ingress_ports, var.security_group_ingress_sgs) : join(",", v) => v }
}

variable "security_group_ingress_ports" {
    type = list(number)
    description = "Ingress allow port numbers"
    default = [
        80
    ]
}

variable "security_group_ingress_cidrs" {
    type = list(string)
    description = "Ingress allow cidrs"
    default = []
}

variable "security_group_egress_cidrs" {
    type = list(string)
    description = "Egress allow cidrs"
    default = []
}

variable "security_group_ingress_sgs" {
    type = list(string)
    description = "Ingress allow security_groups"
    default = []
}

variable "security_group_egress_sgs" {
    type = list(string)
    description = "egress allow security_groups"
    default = []
}

variable "security_group_ingress_allow_self" {
    type = bool
    description = "Ingress allow yourself security_group"
    default = false
}

variable "security_group_tags" {
    type = map(string)
    default = {}
    description = "Additional tags for the Security Group"

    validation {
        condition = length(setintersection(keys(var.security_group_tags),
        ["Name", "Env", "VpcId"])) == 0
        error_message = "Key names, Name and Env, VpcID are reserved. Not allowed to use them."
    }
}
