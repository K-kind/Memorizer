# Memorizer
英単語を楽しく効率的に学習するためのアプリです。

https://memorizer.tech
<img width="1200" alt="スクリーンショット 2020-02-03 11 01 07" src="https://user-images.githubusercontent.com/55728594/73620288-7ddce280-4674-11ea-9f5e-d10ff139eea6.png">

## アプリ概要
英語の辞書を見ながら単語を学び、後日復習するステップを繰り返して、英単語を覚えていただきます。

より効率的に覚えるために、以下の3つの仕組みを利用します。
- 分散学習: 1回目の復習は1日後、2回目は7日後…というサイクルを管理
- クイズ化: 単語に関するクイズを自作して答える
- チャンク化: 関連語や、関連する画像と一緒に記憶する

さらに、レベルアップや学習数ランキング等のモチベーションを維持するための機能も搭載しています。

## 工夫した点
- 非同期通信、jQueryを活用した、スムーズなUI
- あとで学習するリストを保存する機能や学習設定など、細部への気遣い
- メール送信や画像アップロードなどの重い処理を非同期で行うためのバックグラウンドジョブの活用
- レスポンシブ対応レイアウト
- 有用な初期データを持ったテストユーザーを複数用意（同時並行ログインにも対応）
- お問い合わせ受付と管理者への通知機能など、ユーザーからのフィードバックを重視
- 継続的な改善の基礎となる、System Specを中心とした堅牢なテスト
- DRYな設定、軽量なDocker Imageを模索し最適化されたCI/CDパイプライン
- UXを高めるために理解して活用した各種AWSインフラ
- テンプレート付きのGitHub IssuesとPull requestを活用した、擬似チーム開発

## 使用技術
### バックエンド
- Ruby 2.6.5
- Ruby on Rails 6.0.2
- MySQL 5.7
- Nginx 1.15.8
- Redis 5.0.9

### フロントエンド
- HTML (slim)
- Sass (BEM)
- Javascript, jQuery

### エディター
- VSCode

### インフラ
- AWS
  - EC2, ECS, ECR, ELB
  - RDS, ElastiCache
  - S3, CloudFront
  - VPC, IAM, Route53, SES
- CircleCI
- Docker, Docker Compose, docker-sync, BuildKit

<img width="1200" alt="インフラ構成図" src="https://user-images.githubusercontent.com/55728594/83349907-2543fa80-a373-11ea-9841-460694128064.jpg">

## 使用したgem等
- テスト、静的解析
  - rspec, capybara, factory_bot_rails, vcr
  - rubocop
  - bullet
- 画像アップロード
  - carrierwave, fog
- ビューの補助機能
  - ransack, kaminari
  - Action Text
- javascriptライブラリ
  - chartkick, fullcalendar-rails
- メール送信、SNSログイン
  - aws-ses
  - omniauth
- バッチ処理
  - whenever
- アセットコンパイル
  - webpacker
  - asset_sync
- ジョブアダプター
  - sidekiq
