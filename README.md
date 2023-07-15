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

#### 4. systemd の設定
https://github.com/puma/puma/blob/v5.6.6/docs/systemd.md
```console
$ sudo vi /etc/systemd/system/realworld.service
```

```service
[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
# Puma supports systemd's `Type=notify` and watchdog service
# monitoring, if the [sd_notify](https://github.com/agis/ruby-sdnotify) gem is installed,
# as of Puma 5.1 or later.
# On earlier versions of Puma or JRuby, change this to `Type=simple` and remove
# the `WatchdogSec` line.
Type=notify

# If your Puma process locks up, systemd's watchdog will restart it within seconds.
WatchdogSec=10

User=<ユーザー名>

WorkingDirectory=/hogehoge/realworld

# Helpful for debugging socket activation, etc.
# Environment=PUMA_DEBUG=1
Environment=RAILS_ENV=production
Environment=RAILS_SERVE_STATIC_FILES=1

ExecStart=/bin/bash -lc 'bundle exec puma -C config/puma.rb'

Restart=always

[Install]
WantedBy=multi-user.target
```

```console
$ sudo systemctl daemon-reload
$ sudo systemctl enable realworld
$ sudo systemctl start realworld
```

#### 5. Nginx の設定
```console
$ sudo vi /etc/nginx/conf.d/realworld.conf
```

```nginx
upstream puma {
  server unix://<hogehoge>/realworld/tmp/sockets/puma.sock;
}
server {
  listen       80;
  server_name  <ドメイン名>;
  root /<hogehoge>/realworld/public;
  access_log  /var/log/nginx/access.log  main;
  error_log /var/log/nginx/error.log;
  sendfile            on;
  tcp_nopush          on;
  tcp_nodelay         on;
  keepalive_timeout   65;
  types_hash_max_size 2048;
  client_max_body_size 100M;
  include             /etc/nginx/mime.types;

  location / {
    proxy_pass http://puma;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_redirect off;
    proxy_connect_timeout 30;
  }

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
    root /hogehoge/realworld/public;
  }

  location ^~ /packs/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
    root /hogehoge/realworld/public;
  }
}
```

#### 6. アプリケーション起動
```console
$ sudo systemctl start realworld
$ sudo systemctl status realworld
$ sudo systemctl stop realworld
```
