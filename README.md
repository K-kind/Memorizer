# Memorizer
Memorizerは、楽しく、効率的な英単語学習をサポートするアプリです。
https://memorizer.tech
<img width="1200" alt="スクリーンショット 2020-02-03 11 01 07" src="https://user-images.githubusercontent.com/55728594/73620288-7ddce280-4674-11ea-9f5e-d10ff139eea6.png">

## アプリ概要
- 3つの仕組みを利用して、英単語の学習をサポートします。
  - 分散学習: 1回目の復習は1日後、2回目は7日後…というサイクルを管理。
  - クイズ化: 自分で単語に関するクイズを作って、復習する。
  - チャンク化: 関連語や、関連する画像と一緒に記憶する。
- レベルアップ、学習数ランキング等、モチベーションを維持する機能も搭載しています。

## 機能一覧

## 工夫した点
- 非同期処理、jQueryを活用して、スムーズな表示を目指しました。
- あとで学習するリストなど、細かい機能にもこだわりました。
- ヘルプ、お問い合わせページなど、ユーザーからのフィードバックを重視しました。
- テストユーザーを多数用意し、時間ごとにローテーションを組み、公平に体験できるように工夫しました。
- GitHub上で、機能追加ごとにIssueとbranchを作成し、プルリクを活用しました。

## 使用技術
### バックエンド
- Ruby 2.6.5
- Ruby on Rails 6.0.2
- MySQL 5.7
- Nginx 1.15.8
- AWS
  - EC2, RDS, VPC, IAM, ELB, Route53, S3, SES
- Docker, docker-compose, docker-sync
- CircleCI

### フロントエンド
- HTML (slim)
- Sass (BEM規則)
- Javascript
- jQuery

### エディター
- VSCode

## 使用したgem等
- テスト、静的解析
  - rspec, capybara, factory_bot_rails
  - rubocop
  - faker
- 画像アップロード
  - carrierwave, fog
- Viewの補助機能
  - ransack, kaminari
  - Action Text
- javascriptライブラリ
  - chartkick, fullcalendar-rails
- メール送信、SNSログイン
  - aws-ses
  - omniauth
- バッチ処理
  - whenever
