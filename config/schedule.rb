set :output, '/var/www/fortuna_luca/shared/log/cron.log'
job_type :bin, 'cd :path && bundle exec ruby ./bin/:task :output'

every :monday, at: '9am' do
  bin :send_digest
end

every 1.hours do
  bin :send_last_tweets
end

every 30.minutes do
  bin :send_next_event
end
