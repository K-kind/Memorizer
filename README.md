# Memorizer
Memorizerは、楽しく、効率的な英単語学習をサポートするアプリです。
https://memorizer.tech
![Uploading スクリーンショット 2020-01-30 10.55.31.png…]()

## アプリ概要
- 3つの仕組みを利用して、英単語の学習をサポートします。
  - 分散学習: 1回目の復習は1日後、2回目は7日後…というサイクルを管理。
  - クイズ化: 自分で単語に関するクイズを作って、復習する。
  - チャンク化: 関連語や、関連する画像と一緒に記憶する。
- さらに、レベルアップ、学習数ランキング等、モチベーションを維持する機能もあります。

## 工夫した点
  - 非同期処理、jQueryを活用して、スムーズな表示を目指しました。
  - あとで学習するリストなど、細かい機能にもこだわりました。
  - ヘルプ、お問い合わせページなど、ユーザーからのフィードバックを重視しました。
  - テストユーザーを多数用意し、時間ごとにローテーションを組み、公平に体験できるように工夫しました。

## 使用技術
- Ruby 2.6.5
- Ruby on Rails 6.0.2
- MySQL 5.7
- Nginx 1.15.8
- HTML
- Sass
- Javascript
- jQuery
- AWS
  - EC2, RDS, VPC, ALB, Route53, S3, SES, IAM
- Docker, docker-compose, docker-sync
- CircleCI

## 使用したgem
- テスト、静的解析
  - rspec, capybara, factory_bot_rails
  - rubocop
  - faker
- 画像アップロード
  - carrierwave
- Viewの補助機能
  - ransack, kaminari
- javascriptライブラリ系
  - chartkick, fullcalendar-rails
- インフラ補助
  - aws-ses, fog
  - omniauth
- cron処理
  - whenever
