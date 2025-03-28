# Sample app

## Required

- Docker

## ローカルサーバーの起動

```bash
cd sample-app
# https://github.com/sora-corporation/web-app-deploy-basic/wiki/master.key
# を config/master.key に保存
docker compose up -d
# DBのセットアップとマイグレーション
docker compose exec rails bundle exec rails db:create
docker compose exec rails bundle exec rails db:migrate
```

http://localhost:3000/up にブラウザでアクセスし、画面が表示されればOK

## APIの確認

`postman_collection.json` を [Postman](https://www.postman.com/) で読み込むと一通りのAPIを確認することができる。
