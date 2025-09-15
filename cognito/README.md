# ShogiProject Cognito Infrastructure

このディレクトリは、ShogiProjectで使用する既存のAWS Cognitoリソースを Terraform管理下に取り込むための設定です。

## 概要

- 既存のCognito User PoolとUser Pool Clientをインポート
- Terraform state管理による構成管理
- 本番環境での破壊防止機能付き

## セットアップ手順

### 1. 事前準備

```bash
# 必要なAWS情報を取得
aws cognito-idp list-user-pools --max-items 20 --profile shogi
aws cognito-idp list-user-pool-clients --user-pool-id <USER_POOL_ID> --profile shogi
```

### 2. 設定ファイルの作成

```bash
# サンプルファイルから設定ファイルを作成
cp terraform.tfvars.sample terraform.tfvars

# 実際の値を設定
vi terraform.tfvars
```

terraform.tfvarsの例：
```hcl
aws_region  = "ap-northeast-1"
aws_profile = "shogi"

user_pool_id        = "ap-northeast-1_xxxxxxxxx"
user_pool_client_id = "xxxxxxxxxxxxxxxxxxxxxxxxxx"

project_name = "shogi-project"
```

### 3. Terraformの初期化

```bash
terraform init
```

### 4. 既存リソースのインポート

```bash
./import.sh
```

### 5. 設定の確認

```bash
terraform plan
```

### 6. 適用（必要に応じて）

```bash
terraform apply
```

## ファイル構成

- `main.tf` - プロバイダー設定
- `variables.tf` - 変数定義
- `cognito.tf` - Cognitoリソース定義
- `outputs.tf` - 出力値定義
- `import.sh` - 既存リソースインポートスクリプト
- `terraform.tfvars.sample` - 設定ファイルサンプル

## 注意事項

- `prevent_destroy = true` により、誤ってリソースを削除することを防いでいます
- `terraform.tfvars` には機密情報が含まれるため、Gitには含めません
- インポート後は、実際の設定と Terraform設定に差分がないことを確認してください

## SSMパラメータとの連携

ShogiProjectでは以下のSSMパラメータでCognito情報を管理しています：
- `/Cognito/user_pool_id`
- `/Cognito/client_id`  
- `/Cognito/client_secret`

Terraform管理に移行する際は、これらのパラメータ値の整合性を確認してください。

## トラブルシューティング

### インポートに失敗する場合

1. AWSプロファイルの確認：`aws sts get-caller-identity --profile shogi`
2. リソースIDの確認：terraform.tfvarsの値が正しいか確認
3. 権限の確認：Cognitoに対する読み取り/書き込み権限があるか確認

### 設定差分が発生する場合

`terraform plan` で差分が表示される場合、cognito.tfの設定を実際のリソース設定に合わせて調整してください。