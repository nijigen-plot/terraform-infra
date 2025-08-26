# dataブロックは外部からの情報を参照するためのもので、読み込みのみ。
# これの目的としては非推奨であるap-northeast-1bを除外して利用可能なAZがいくつあるかをlocalsに渡す
data "aws_availability_zones" "availability_zones" {
    state = "available"

    exclude_names = [
        "ap-northeast-1b"
    ]
}

locals {
    number_of_availability_zones = length(
        data.aws_availability_zones.availability_zones.names
    )
}
