# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

ENV.each { |k, v| env(k, v) }
require File.expand_path(File.dirname(__FILE__) + '/environment')
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"
env :PATH, ENV['PATH']
# job_type :rbenv_rake, %q!eval "$(rbenv init -)"; cd :path && :environment_variable=:environment bundle exec rake :task --silent :output!

# every '0 0 * * *' do # 毎日0時0分
#   command "echo 'learned_contents.till_next_review -1'"
#   runner 'lib/tasks/set_date.rb', :environment_variable => 'RAILS_ENV'
# end

# every '*/10 * * * *' do # 0分 10分 ..
#   command 'echo `date`'
#   runner 'lib/tasks/update_test_user.rb', :environment_variable => 'RAILS_ENV'
# end

every '0 0,12 * * *' do # 毎日0時, 12時
  command 'echo `date`'
  runner 'UpdateTestUser.new', :environment_variable => 'RAILS_ENV'
end
