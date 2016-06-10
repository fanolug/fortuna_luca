set :output, '/var/www/fortuna_luca/shared/log/cron.log'
job_type :bin, 'cd :path && bundle exec ruby ./bin/:task :output'

every :monday, at: '9am' do
  bin :send_digest
end

every :hour do
  runner 'Bot.new.send_last_rss_items(minutes: 60)'
end
