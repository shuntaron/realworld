## RealWorld のデプロイ
RealWorld のバックエンド API を AWS 上にデプロイする

### ステップ1
RealWorld のバックエンドの API を AWS 上にデプロイする  

### 要件
- 各エンドポイントに対してリクエストを送ると、正しいレスポンスが返ってくること
- API サーバー (EC2 もしくは ECS) とデータベースサーバー (RDS) は別々に構築すること
- データベースサーバーは、API サーバーからのみアクセスできるようにすること
- 独自ドメインでアクセスできるようにすること
- SSL 化 (HTTPS 化) すること

### 手順

#### 1. リポジトリのクローン
```console
$ git clone https://github.com/shuntaron/realworld.git
$ cd realworld
```
