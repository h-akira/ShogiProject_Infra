# ShogiProject CodeBuild Terraform Configuration

このディレクトリには、ShogiProjectのCodeBuildプロジェクトをTerraformで管理する設定が含まれています。

## 管理対象リソース

- **CodeBuild Project**: `build-sgp-app`
  - GitHubリポジトリ: 設定可能
  - main ブランチへのPUSHトリガー
  - Amazon Linux 2 x86_64 Standard 5.0 環境

- **CodeBuild Webhook**: GitHubとの連携設定

- **IAM Role**: `codebuild-build-sgp-app-service-role`
  - CodeBuild サービス用ロール

- **IAM Policies**:
  - `CodeBuildBasePolicy-build-sgp-app-ap-northeast-1`: CodeBuild基本権限
  - `policy-sgp-app-exec-sam`: SAM実行用権限

## セットアップ

### 初期化とインポート

```bash
# 実行可能権限を付与
chmod +x import.sh

# インポートスクリプトの実行
./import.sh
```

### 変数設定の確認

設定値は `terraform.tfvars` に記載されています：
- プロジェクト名
- 環境設定 
- AWSプロファイル
- GitHubリポジトリURL
- サービスロールARN

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
- `codebuild.tf`: CodeBuildプロジェクト設定
- `webhook.tf`: GitHub Webhook設定
- `iam.tf`: IAMロールとポリシー設定
- `terraform.tfvars`: 設定値
- `import.sh`: インポートスクリプト

## 汎用性について

このTerraform設定は複数のAWSアカウントで使用できるよう設計されています：

- **動的アカウントID取得**: `data.aws_caller_identity.current.account_id` を使用
- **動的リージョン取得**: `data.aws_region.current.name` を使用  
- **設定可能な変数**: 
  - `aws_profile`: 使用するAWSプロファイル
  - `aws_region`: デプロイ先リージョン
  - `codebuild_project_name`: CodeBuildプロジェクト名
  - `created_date`: タグ用作成日（YYYYMMDD形式）
  - `environment`: 環境名

## 注意事項

- 本番環境のCodeBuildプロジェクトを管理しています
- 変更前には必ず `terraform plan` で確認してください
- サービスロールやGitHub連携の変更には注意が必要です
- 他のアカウントにデプロイする際は `terraform.tfvars` で適切な値を設定してください