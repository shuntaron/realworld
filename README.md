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
#### 2. master.key と .env の転送
```console
$ scp -i ~/.ssh/<秘密鍵>.pem config/master.key <ユーザー名>@<IPアドレス>:realworld/config
$ scp -i ~/.ssh/<秘密鍵>.pem .env <ユーザー名>@<IPアドレス>:realworld
```

#### 3. データベースの作成
```console
$ rails db:create
$ rails db:migrate
```
