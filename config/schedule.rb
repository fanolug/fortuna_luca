set :output, '/var/www/fortuna_luca/shared/log/cron.log'
job_type :bin, 'cd :path && bundle exec ruby ./bin/:task :output'

every :monday, at: '9am' do
  bin :send_digest
end

every :hour, at: 15 do
  runner 'Calendar.new.notify'
end

every :day, at: '10:30am' do
  runner 'Comics.new.notifyxkcd'
end

every '05 6-23 * * *' do
  runner 'Comics.new.notifytous'
end
