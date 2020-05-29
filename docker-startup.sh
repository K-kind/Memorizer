#!/bin/sh

echo "starting db:migration..."
bin/rails db:migrate
bundle exec puma -C config/puma.rb
