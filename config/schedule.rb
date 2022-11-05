set :output, '/var/www/fortuna_luca/shared/log/cron.log'
job_type :bin, 'cd :path && bundle exec ruby ./bin/:task :output'

every 1.hours do
  bin :send_last_tweets_media
end
