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
│       ├── env (これは使ってない。)
│       │   ├── README.md
│       │   ├── dev.tfvars
│       │   ├── prod.tfvars
│       │   └── stg.tfvars
│       ├── modules
│       │   ├── outputs.tf
│       │   ├── variables.tf
│       │   └── `aws_service_name`.tf
│       ├── provider.tf
│       └── resources.tf
└── github
    └── repository
        └── main.tf
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
    key          = "aws/${service_name}/${service_name}.tfstate"
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

### import

https://developer.hashicorp.com/terraform/language/import

```
import {
  to =
  id =
}
```

1. importブロックを上記のように追加する
  1. to -> resourcesの文字列
  2. id = 1で定義したresourcesに対応する文字列。よって`id`のキー部分もリソースによって違うと思う
2. `terraform plan`を実行
3. 出てきた差分をtxtなんかにして出力
4. それをresourcesに適用する。（AIとかつかうとはやいよ）
  1. 3,4番はこれを繰り返すことで足りないリソース判明→importで全て取り込めるようになる
5. 差分が無くなったら`terraform apply`!

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
