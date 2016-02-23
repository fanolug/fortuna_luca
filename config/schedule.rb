set :output, '/var/www/fortuna_luca/shared/log/cron.log'
job_type :bin, 'cd :path && ./bin/:task :output'

every :monday, at: '9am' do
  bin :send_digest
end
