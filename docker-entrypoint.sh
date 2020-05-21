#!/bin/sh

echo "starting db:migration..."
bin/rails db:migrate
echo "starting service cron..."
sudo service cron start
echo "updating crontab..."
bundle exec whenever --update-crontab

$@
