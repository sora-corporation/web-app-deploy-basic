# SPAをインターネットに公開する

データベース等を持たない、フロントエンドのみで完結するアプリケーションをインターネットに公開する手順の紹介。  
サンプルアプリケーションは [Next.jsの公式サンプルブログアプリ](https://github.com/vercel/next.js/tree/canary/examples/blog-starter) を利用する。  
`sample-app/` 以下は

```bash
npx create-next-app --example blog-starter sample-app
```

でダウンロードしたサンプルアプリケーションで、 `sample-app/_posts/` 以下にMarkdown形式で書いたドキュメントをWebで表示可能にするというもの。

## サンプルアプリをローカルマシンで起動する方法

```bash
cd sample-app
npm i
npm run dev
```

http://localhost:3000 で開発サーバーが起動し、ブラウザで確認が可能。

