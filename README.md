# ShogiProject Infrastructure

このリポジトリはShogiProjectのインフラストラクチャをIaC（Infrastructure as Code）で管理します。

## アーキテクチャ概要

ShogiProjectは以下のAWSサービスを使用します：

- **Cognito**: ユーザー認証・認可
- **DynamoDB**: アプリケーションデータの保存
- **S3**: 静的ファイルのホスティング
- **CodeBuild**: アプリケーションのビルドとデプロイ
- **Lambda + API Gateway**: バックエンドAPI（SAMでデプロイ）
- **CloudFront**: CDNとして静的ファイルとAPIの配信
- **Systems Manager Parameter Store**: 環境変数の管理

## インフラ構築手順

ShogiProjectのインフラは以下の順序で構築する必要があります：

### 1. Cognito の作成 (Terraform)

```bash
cd cognito
terraform init
terraform plan
terraform apply
```

### 2. DynamoDB の作成 (Terraform)

```bash
cd dynamodb
terraform init
terraform plan
terraform apply
```

### 3. S3 の手動作成

- 詳細は `ManuallyCreatedResources/S3.md` を参照
- 静的ウェブサイトホスティング用のS3バケットを手動作成

### 4. Parameter Store の設定

WAMBDAアプリケーション用の環境変数をAWSコンソールまたはCLIで設定：

```bash
aws ssm put-parameter --name "/wambda/debug" --value "true" --type String --overwrite
aws ssm put-parameter --name "/wambda/use_mock" --value "false" --type String --overwrite
aws ssm put-parameter --name "/wambda/no_auth" --value "false" --type String --overwrite
aws ssm put-parameter --name "/wambda/deny_signup" --value "false" --type String --overwrite
aws ssm put-parameter --name "/wambda/deny_login" --value "false" --type String --overwrite
aws ssm put-parameter --name "/wambda/log_level" --value "INFO" --type String --overwrite
```

### 5. CodeBuild の作成 (Terraform)

ShogiProjectでは3つのCodeBuildプロジェクトを使用します：

#### 5-1. メインアプリケーション用CodeBuild

```bash
cd codebuild_app
terraform init
terraform plan
terraform apply
```

- **用途**: ShogiProjectメインアプリケーションのビルドとデプロイ
- **トリガー**: GitHubリポジトリへのpush
- **デプロイ内容**: Lambda関数、API Gateway、静的ファイル

#### 5-2. 分析機能用CodeBuild

```bash
cd codebuild_app_analysis
terraform init
terraform plan
terraform apply
```

- **用途**: 分析機能アプリケーションのビルドとデプロイ
- **トリガー**: GitHubリポジトリへのpush
- **デプロイ内容**: 分析用Lambda関数

#### 5-3. 外形監視用CodeBuild

```bash
cd codebuild_synthetic_monitoring
terraform init
terraform plan
terraform apply
```

- **用途**: Selenium外形監視システムのビルドとデプロイ
- **トリガー**: GitHubリポジトリへのpush
- **デプロイ内容**: Selenium + Chrome Lambdaコンテナイメージ、EventBridge、SNS

### 6. SAM のデプロイ

CodeBuildにより自動実行されます：
- Lambda関数の作成
- API Gatewayの作成
- 必要なIAMロールの作成

### 7. CloudFront の手動作成

- 詳細は `ManuallyCreatedResources/CloudFront.md` を参照
- オリジンとしてS3バケットとAPI Gatewayを指定

## ディレクトリ構成

```
ShogiProject_Infra/
├── README.md                           # このファイル
├── cognito/                            # Cognito用Terraform
│   ├── main.tf
│   ├── cognito.tf
│   ├── outputs.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── terraform.tfvars.sample
├── dynamodb/                           # DynamoDB用Terraform
│   ├── main.tf
│   ├── dynamodb.tf
│   ├── variables.tf
│   └── terraform.tfvars
├── codebuild_app/                      # メインアプリ用CodeBuild
│   ├── main.tf
│   ├── codebuild.tf
│   ├── iam.tf
│   ├── webhook.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── terraform.tfvars.sample
├── codebuild_app_analysis/             # 分析機能用CodeBuild
│   ├── main.tf
│   ├── codebuild.tf
│   ├── iam.tf
│   ├── webhook.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── terraform.tfvars.sample
├── codebuild_synthetic_monitoring/     # 外形監視用CodeBuild
│   ├── main.tf
│   ├── codebuild.tf
│   ├── iam.tf
│   ├── webhook.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── terraform.tfvars.sample
└── ManuallyCreatedResources/           # 手動作成リソースの手順書
    ├── S3.md
    └── CloudFront.md
```

## タグポリシー

全リソースに以下の共通タグを適用します：

- `Name`: リソースの実際の名前
- `Environment`: 環境名（production/staging など）
- `Created`: 作成日（YYYYMMDD形式）

## 前提条件

- AWS CLI設定済み
- Terraform 1.0以上
- 適切なAWS権限を持つプロファイル設定

## 設定ファイル

各Terraformディレクトリには `terraform.tfvars.sample` ファイルがあります。
これをコピーして `terraform.tfvars` を作成し、環境に合わせて値を設定してください。

## 注意事項

- リソース作成の順序を守ってください
- 手動作成リソースは `ManuallyCreatedResources/` の手順書に従ってください
- 3つのCodeBuildプロジェクトはそれぞれ独立しています：
  - `codebuild_app`: メインアプリケーション（ShogiProject）
  - `codebuild_app_analysis`: 分析機能（ShogiProject_Analysis）
  - `codebuild_synthetic_monitoring`: 外形監視（ShogiProject_SyntheticMonitoring）
- CodeBuildのWebhook機能により、対応するGitHubリポジトリへのpush時に自動ビルド・デプロイが実行されます
- 外形監視のCodeBuildはDockerコンテナイメージをECRにプッシュするため、特権モード（privileged_mode）が有効になっています