Terraformで作るインフラ群をまとめるリポジトリ

[Terraformではじめる実線IaC](https://www.oreilly.co.jp/books/9784814400133/)を参考にしています。

## VSCode 拡張

https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform

## Setup

1. touch variables.tf
2. terraform init

### backend

`backend.tf`として記載


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
