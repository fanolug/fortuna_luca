task :send_allerta_meteo_report do
  FortunaLuca::Reports::AllertaMeteo.new(Date.today.succ).call
end
