Terraformで作るインフラ群をまとめるリポジトリ

[Terraformではじめる実線IaC](https://www.oreilly.co.jp/books/9784814400133/)を参考にしています。

## VSCode 拡張

https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform

## Setup

フォルダ階層はこんな感じになってます。

```
.
├── README.md
├── aws (プロバイダ名)
│   ├── ecs (サービス名)
│   │   ├── backend.tf (ステート管理設定)
│   │   ├── modules (サービス名毎のリソース定義、変数定義、アウトプット定義)
│   │   │   ├── `aws_service_name`.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── provider.tf (プロバイダ定義)
│   │   └── resources.tf (変数に用いる値を定義)
│   └── vpc
│       ├── backend.tf
│       ├── modules
│       │   ├── outputs.tf
│       │   ├── variables.tf
│       │   └── `aws_service_name`.tf
│       ├── provider.tf
│       └── resources.tf
├── github
│   ├── README.md
│   └── repository
│       ├── backend.tf
│       ├── modules
│       │   ├── repository.tf
│       │   └── variables.tf
│       ├── provider.tf
│       └── resources.tf
other
```

- `terraform init`までの作り方

1. 適切なプロバイダ名、サービス名を決定してフォルダを作る
2. `provider.tf`,`backend.tf`を作る。設定は既存サービスのものを参考に
3. `terraform init`
4. `terraform workspace new dev`

### backend

基本AWS S3でステート管理。1.10から[S3単体でもロックが可能](https://github.com/hashicorp/terraform/pull/35661)になったのでそれを使ってます。

```
terraform {
  backend "s3" {
    bucket       = "nijipro-terraform"
    key          = "${provider_name}/${service_name}/${service_name}.tfstate"
    region       = "ap-northeast-1"
    profile      = "terraform"
    use_lockfile = true
  }
}
```

### provider

プロバイダによって設定は変わります。AWSは以下

```
provider "aws" {
  default_tags {
    tags = {
      Resource = "Terraform"
    }
  }
}
```

## provider

### AWS

現状はterraform勉強用。余裕あったら既存リソースを取り込む

### GitHub

リポジトリ作成はこちらでやる。余裕あったら既存リポジトリを取り込む

## Knowledge

https://developer.hashicorp.com/terraform/docs

https://github.com/terraform-aws-modules

### Input Variable

`variables.tf`というファイルで`variable`で宣言するのが一般的かも
`var.variable_name`でアクセスする

### Command

- fmt
- validate
- plan
  - -out xxxx: xxxxに差分を出力
    - 差分出力からのapplyで差分反映みたいなことができる
  - -target xxxx: 特定のリソースを指定して差分を出力
- apply
  - -auto-approve: 変更について自動でapproveする
  - -parrallelism: 並列処理数
- destroy
  - apply -destroyのエイリアス。リソースを破棄する
- import
  - 構築済みリソースの取り込み
    - planで差分を見ながら吸収して合わせるみたいなことができる。
- state
  - list: terraform管理中のリソース一覧を出力
  - show: 特定のリソースの詳細を表示
  - mv: 特定リソースのterraformアドレス変更(再作成することなくアドレスを付け替える)
    - リソースのID等を変更するわけではない
  - rm: 特定リソースステートの削除
    - ステートだけ削除。他のステートの管理に置きたい時などにimportと組み合わせて使ったりなど
- workspace
