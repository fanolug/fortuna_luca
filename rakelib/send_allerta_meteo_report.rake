task :send_allerta_meteo_report do
  FortunaLuca::Reports::AllertaMeteo.new.call
end
