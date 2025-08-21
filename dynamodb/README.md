# ShogiProject DynamoDB Terraform Configuration

このディレクトリには、ShogiProjectのDynamoDBテーブルをTerraformで管理する設定が含まれています。

## 管理対象リソース

- **DynamoDB テーブル**: `table-sgp-pro-main`
  - 棋譜、タグ、ユーザーデータの保存
  - 複数のLSI/GSIインデックス

## セットアップ

### 初期化

```bash
# Terraformの初期化
terraform init
```

### 変数設定

```bash
# terraform.tfvarsファイルをコピーして設定
cp terraform.tfvars.example terraform.tfvars
# 必要に応じて値を編集
```

### 設定の確認

```bash
# プランの確認
terraform plan

# 変更の適用
terraform apply
```

## ファイル構成

- `main.tf`: プロバイダー設定
- `variables.tf`: 変数定義
- `dynamodb.tf`: DynamoDBテーブル設定
- `terraform.tfvars.example`: 変数設定例
- `import.sh`: 既存リソースのインポートスクリプト

## 注意事項

- 本番環境のDynamoDBテーブルを管理しています
- 変更前には必ず `terraform plan` で確認してください
- 不用意な変更はデータ損失につながる可能性があります

## インフラ構成の変更について

S3とCloudFrontはTerraformでの管理を廃止し、現在はDynamoDBのみを管理しています。
これにより、データベース部分の管理を明確化し、より安全な運用を可能にしています。