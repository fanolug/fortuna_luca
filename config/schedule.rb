set :output, '/home/deployer/fortuna_luca/log/cron.log'
job_type :bin, 'cd :path && ./bin/:task :output'

every :monday, at: '9am' do
  bin :send_digest
end
