require_relative '../lib/fortuna_luca/reports/cycling'

task :send_cycling_report do
  FortunaLuca::Reports::Cycling.new(Date.today).call
end
