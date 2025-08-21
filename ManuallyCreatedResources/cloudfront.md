# CloudFront ディストリビューション手動作成手順

ShogiProjectのCDN用CloudFrontディストリビューションを手動で作成します。

## 作成するリソース

- CloudFrontディストリビューション
- Origin Access Control (OAC)
- 2つのオリジン（S3バケット、API Gateway）
- キャッシュビヘイビアの設定

## 前提条件

以下のリソースが事前に作成されている必要があります：
- S3バケット（静的ウェブサイトホスティング設定済み）
- API Gateway（SAMデプロイ済み）

## 手順

### 1. Origin Access Control (OAC) の作成

CloudFrontコンソールで「Origin access control settings」を選択：

```
名前: your-project-oac-[環境名]
説明: Origin access control for your project
署名動作: リクエストに署名する
署名リクエスト: リクエストヘッダーを含めない
オリジンタイプ: S3
```

### 2. CloudFrontディストリビューションの作成

CloudFrontコンソールで「Create distribution」を選択：

#### Origin settings

**オリジン #1 (S3バケット)**
```
オリジンドメイン: [S3バケット名].s3.ap-northeast-1.amazonaws.com
名前: S3-your-project-bucket
Origin access: Origin access control settings (recommended)
Origin access control: 上記で作成したOACを選択
```

**オリジン #2 (API Gateway) - 後で追加**
```
オリジンドメイン: [API Gateway ID].execute-api.ap-northeast-1.amazonaws.com
名前: APIGateway-your-project-api
Origin path: /prod (SAMのデフォルトステージ)
Protocol: HTTPS only
```

#### Default cache behavior

```
Path pattern: Default (*)
Origin or origin group: S3-your-project-bucket
Viewer protocol policy: Redirect HTTP to HTTPS
Allowed HTTP methods: GET, HEAD
Cache key and origin requests: CachingOptimized
```

#### Distribution settings

```
Price class: Use all edge locations (best performance)
Alternate domain name (CNAME): your-domain.example.com (独自ドメインがある場合)
Custom SSL certificate: 証明書を選択（独自ドメイン使用時）
Default root object: index.html
```

### 3. 追加のCache Behaviorの作成

API Gateway用のキャッシュビヘイビアを追加：

```
Path pattern: /api/*
Origin or origin group: APIGateway-your-project-api  
Viewer protocol policy: HTTPS only
Allowed HTTP methods: GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE
Cache policy: CachingDisabled
Origin request policy: CORS-S3Origin
Response headers policy: SimpleCORS
```

### 4. S3バケットポリシーの更新

CloudFrontからのアクセスのみを許可するように、S3バケットポリシーを更新：

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR_BUCKET_NAME/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::ACCOUNT_ID:distribution/DISTRIBUTION_ID"
                }
            }
        }
    ]
}
```

**注意**: 以下を実際の値に置き換えてください：
- `YOUR_BUCKET_NAME`: S3バケット名
- `ACCOUNT_ID`: AWSアカウントID
- `DISTRIBUTION_ID`: CloudFrontディストリビューションID

### 5. DNS設定 (独自ドメイン使用時)

Route 53またはDNSプロバイダーでCNAMEレコードを設定：

```
Type: CNAME
Name: your-subdomain
Value: [CloudFrontドメイン名].cloudfront.net
```

### 6. 作成後の確認事項

作成完了後、以下の情報を記録してください：

- **ディストリビューションID**: 
- **ディストリビューションドメイン名**: 
- **作成日**: 

### 7. 動作確認

1. **静的コンテンツの確認**:
   ```
   https://[CloudFrontドメイン]/index.html
   ```

2. **API の確認**:
   ```
   https://[CloudFrontドメイン]/api/[エンドポイント]
   ```

## タグ設定

作成したCloudFrontディストリビューションに以下のタグを設定：

```
Name: your-project-cloudfront-[環境名]
Environment: [環境名]
Created: [作成日 YYYYMMDD]
```

## 注意事項

- CloudFrontの設定変更は反映に15-20分程度かかります
- 本番環境では適切なキャッシュポリシーを設定してください
- API Gatewayの設定はSAMデプロイ後に行ってください
- 独自ドメインを使用する場合は、事前にSSL証明書を取得してください（us-east-1リージョン）

## トラブルシューティング

- **403エラーが発生する場合**: S3バケットポリシーとOACの設定を確認
- **APIが動作しない場合**: API GatewayのオリジンパスとCache Behaviorのパスパターンを確認
- **キャッシュが効かない場合**: Cache Behaviorの設定とTTL値を確認