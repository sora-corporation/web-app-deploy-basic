# 準備

- プロファイル名 `web-app-deploy-basic` で `~/.aws/credentials` にアクセスキーを登録
- state 保存用の S3 バケットを作成

```bash
aws s3api create-bucket --profile web-app-deploy-basic --bucket web-app-deploy-basic-terraform-state --region ap-northeast-1 --create-bucket-configuration LocationConstraint=ap-northeast-1
aws s3api put-bucket-versioning --profile web-app-deploy-basic --bucket web-app-deploy-basic-terraform-state --versioning-configuration Status=Enabled
aws s3api put-public-access-block --profile web-app-deploy-basic --bucket web-app-deploy-basic-terraform-state --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

# 環境情報の設定

`01_static/infra/terraform/terraform.tfvars` に以下の情報を入力して保存する。

```
domain_name = "ドメイン名"
whitelist_cidr_blocks = [
  "[自社のIPアドレス等、セキュアなリソースにも接続を許可するIPアドレス]",
]
deployer_pubkey = "[SSH公開鍵]"
```

# Deployment

```bash
cd 01_static/infra/terraform
# 初回、または module が追加された場合に実行
terraform init
# 差分確認
terraform plan
# 適用
terraform apply
```
