# Terraform GitHub Providerとの連携サンプル

## 概要
- terraformを使用し、GitHubTeamsとメンバーを管理する目的のスケルトン

## apply実行者

### src/terraform.tfvars
- github_organization
  - teamを管理する対象のorganizationを指定する
- github_app_id
  - Terraform実行用のGitHub Appのapp_idを指定する
  - 対象のorg -> Settings -> 左メニューのGitHub Apps
  - 対象のGitHubApps -> Configure -> 画面上部のApp settings
  - 表示されている App ID をコピペする
- github_app_installation_id
  - Terraform実行用のGitHub Appのapp_idを指定する
  - 対象のorg -> Settings -> 左メニューのGitHub Apps
  - 対象のGitHubApps -> Configure -> URL右側の数値をコピペする

### src/github-app.pem
- GitHub App の Private Key である。管理者に問い合わせる
- 共有された Private Key を src/ 直下に `github-app.pem` というファイル名で配置する

### terraformコマンド
```bash
## terraform plan
$ task terraform:plan

## terraform apply
$ task terraform:apply

## terraform destroy
$ task terraform:destroy
```
