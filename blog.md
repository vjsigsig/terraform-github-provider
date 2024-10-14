# Terraformを使ってGitHub Organizationを効率的に管理しよう

こんにちは。vjsigsigです( ´∀｀)b

エンジニアリングマネージャーを拝命し、はや4年が経過しましたが、先日その4年ぶりに実務の現場に参加することとなりました。
その際にお世話になっている顧客のGitHubOrganizationの管理ではterraformを使って管理していました。
調べてみると非常に便利そうなproviderが提供されており、今回はそれを使って非常に効率化が実感できたため紹介します。

## GitHub Providerについて
Terraformを使用してGitHubリソースを管理するためのプロバイダーです。
コードベースでGitHubの組織、リポジトリ、チーム、PRなどを管理できます。

- **組織とリポジトリの管理**: 新しいリポジトリの作成、既存のリポジトリの設定変更、リポジトリの削除がコードベースで可能です。
- **チームとメンバーシップの管理**: 組織内のチームとそのメンバーシップを管理できます。チームの作成、チームへのメンバー追加/削除が行えます。
- **アクセス制御**: リポジトリやチームに対するアクセス権限を設定できます。具体的には、リポジトリのコラボレータ追加やチームのリポジトリアクセス権限の設定が可能です。
- **プルリクエストとイシューの管理**: プルリクエストやイシューの作成、更新、クローズが可能です。

このプロバイダーを使うことで、インフラストラクチャと同様にGitHubリソースもコードで管理できるようになり、一貫性のある管理と自動化が実現できます。

## 下準備

- 基本的な準備は公式ドキュメントに従って進めるだけで問題ありません。
  - [Terraform GitHub Provider](https://registry.terraform.io/providers/integrations/github/latest/docs)
- 引っかかり所は `Authentication` の項目。GitHub CLI、OAuth/Personal Access Token、GitHub App の3種類があり、どれを選択して良いかという事
- 結論から言うと、私はGitHub Appの方で構築しました。
- Personal Access Tokenは現在 `Fine-grained personal access tokens` と `Tokens (classic)` の2種類が存在しており、Token(classic)の方は将来廃止されそうな雰囲気です。
 - では `Fine-grained personal access tokens` の方にしたいところですが、ベータ版でまだclassicが必要なユースケースがあったりと、選択するにはちょっと早いと判断しました。
- GitHub Appそのものについての解説はここでは省略します。

### GitHub Appに必要な権限

付与すべき権限についてはユースケースによって異なりますが、今回はOrganizationのメンバーを管理する事にフォーカスした内容なので、下記の権限を付与しました。

- Organization permissions
  - Custom organization roles: Read and write
  - Members: Read and write

## 実行環境

今回はローカルには Terraform をインストールせず、Dockerにて構築しました。

compose.yml
```
services:
  terraform:
    image: hashicorp/terraform:1.9
    container_name: terraform-github-provider
    env_file: .env
    environment:
      - GITHUB_TOKEN=${GITHUB_TOKEN}
    volumes:
      - ./src/:/app
    working_dir: /app
```


## 実装紹介

今回のブログでは紹介しきれない詳細な実装は下記のリポジトリを参照してください。

### 仕組み

- Organizationのteamを作成し、リストのメンバーを追加していくシンプルな内容です。
- 画像
- 新規のメンバーを追加する際は、左側のリストにメンバーを追加したPRを作成し、担当者がApplyするという運用を想定しています。
- main.tfにてメンバーリストをループさせて追加していきます。
