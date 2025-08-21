# ShogiProject Infrastructure

このリポジトリはShogiProjectのインフラストラクチャをIaC（Infrastructure as Code）で管理します。

## アーキテクチャ概要

ShogiProjectは以下のAWSサービスを使用します：

- **DynamoDB**: アプリケーションデータの保存
- **S3**: 静的ファイルのホスティング
- **CodeBuild**: アプリケーションのビルドとデプロイ
- **Lambda + API Gateway**: バックエンドAPI（SAMでデプロイ）
- **CloudFront**: CDNとして静的ファイルとAPIの配信

## インフラ構築手順

ShogiProjectのインフラは以下の順序で構築する必要があります：

### 1. DynamoDB の作成 (Terraform)

```bash
cd dynamodb
terraform init
terraform plan
terraform apply
```

### 2. S3 の手動作成

- 詳細は `ManuallyCreatedResources/S3.md` を参照
- 静的ウェブサイトホスティング用のS3バケットを手動作成

### 3. CodeBuild の作成 (Terraform)

```bash
cd codebuild_app
terraform init
terraform plan
terraform apply
```

### 4. SAM のデプロイ

CodeBuildにより自動実行されます：
- Lambda関数の作成
- API Gatewayの作成
- 必要なIAMロールの作成

### 5. CloudFront の手動作成

- 詳細は `ManuallyCreatedResources/CloudFront.md` を参照
- オリジンとしてS3バケットとAPI Gatewayを指定

## ディレクトリ構成

```
ShogiProject_Infra/
├── README.md                     # このファイル
├── dynamodb/                     # DynamoDB用Terraform
│   ├── main.tf
│   ├── dynamodb.tf
│   ├── variables.tf
│   └── terraform.tfvars
├── codebuild_app/               # CodeBuild用Terraform  
│   ├── main.tf
│   ├── codebuild.tf
│   ├── iam.tf
│   ├── webhook.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── terraform.tfvars.sample
└── ManuallyCreatedResources/    # 手動作成リソースの手順書
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
- CodeBuildのWebhook機能により、GitHubへのpush時に自動ビルド・デプロイが実行されます