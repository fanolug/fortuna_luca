task :send_morning_report do
  FortunaLuca::Reports::Morning.new(Date.today).call
end
