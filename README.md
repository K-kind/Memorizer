# Memorizer
英単語を楽しく効率的に学習するためのアプリです。

https://memorizer.tech
<img width="1200" alt="README 画像 Memorizer" src="https://user-images.githubusercontent.com/55728594/83353475-cb046300-a38d-11ea-8316-7b95436c717e.png">

## アプリ概要
英語の辞書を見ながら単語を学び、後日復習するステップを繰り返して、英単語を覚えていただきます。

より効率的に覚えるために、以下の3つの仕組みを利用します。
- 分散学習: 1回目の復習は1日後、2回目は7日後…というサイクルを管理
- クイズ化: 単語に関するクイズを自作して答える
- チャンク化: 関連語や、関連する画像と一緒に記憶する

さらに、レベルアップや学習数ランキング等のモチベーションを維持するための機能も搭載しています。

## 工夫した点
- 非同期通信、jQueryを活用した、スムーズなUI
- あとで学習したい単語を保存するリストや細かく調整可能な学習設定など、細部への気遣い
- レスポンシブ対応レイアウト
- メール送信、画像アップロード等の重い処理を非同期で行うバックグラウンドジョブの活用
- n+1問題に対応し、応答速度向上を意識したSQLクエリ
- 有用な初期データを持つ複数のテストユーザー（同時ログインにも対応）
- フィードバックを重視するための、お問い合わせ受付と管理者への通知機能
- 細部までカバーするE2Eテストに基づく、継続的な改善のための環境
- DRYな設定、軽量なDocker Imageを模索し最適化されたCI/CDパイプライン
- UXを高めるために理解して活用した各種AWSインフラ
- テンプレート付きのGitHub IssuesとPull requestsを活用した、擬似チーム開発

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
  - コンテナ技術（ECS, ECR, ELB）
  - データベース（RDS, ElastiCache）
  - 静的ファイルホスティング（S3, CloudFront）
  - 基本インフラ（VPC, EC2, Route53, IAM）
  - メール送信（SES）
- CircleCI
- Docker, Docker Compose, docker-sync, BuildKit

<img width="1200" alt="インフラ構成図" src="https://user-images.githubusercontent.com/55728594/83349907-2543fa80-a373-11ea-9841-460694128064.jpg">

## 使用したgem等
- テスト、静的解析
  - rspec, capybara, factory_bot_rails, vcr
  - rubocop
  - brakeman, bullet
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
