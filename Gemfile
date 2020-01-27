source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop'
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails.git', tag: 'v4.0.0.beta3'
  gem 'factory_bot_rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Capistrano
  # gem 'capistrano'
  # gem 'capistrano-bundler'
  # gem 'capistrano-rails'
  # gem 'capistrano-rbenv'
  # gem 'capistrano3-puma'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  # gem 'webdrivers', require: !ENV['SELENIUM_DRIVER_URL']
  # gem 'database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'carrierwave'
gem 'dotenv-rails'
gem 'font-awesome-rails'
gem 'html2slim'
gem 'jquery-rails'
gem 'kaminari'
gem 'ransack'
gem 'slim-rails'

# 機能用gem
gem 'chartkick'
gem 'fullcalendar-rails'
# gem 'momentjs-rails'
gem 'levenshtein'
gem 'trigram'
gem 'unirest'

# consoleを便利にする
gem 'awesome_rails_console'
gem 'pry-rails'

# 外部連携
gem 'aws-ses'
gem 'fog'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-rails_csrf_protection', '~> 0.1'
gem 'omniauth-twitter'

gem 'whenever'
