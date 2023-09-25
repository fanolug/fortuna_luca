task :send_cycling_report do
  FortunaLuca::Reports::Cycling.new(Date.today).call
end
