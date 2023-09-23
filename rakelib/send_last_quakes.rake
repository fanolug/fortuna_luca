require_relative '../lib/fortuna_luca/quakes/ingv_client'
require_relative '../lib/fortuna_luca/telegram/quakes'

task :send_last_quakes do
  start_time = (Time.now - (60 * 60)).strftime("%FT%T")

  events = FortunaLuca::Quakes::INGVClient.new.call(
    starttime: start_time,
    lat: 43.844109, # Fano
    lon: 13.017070,
    maxradiuskm: 250,
    minmag: 3
  )

  FortunaLuca::Telegram::Quakes.new(events).call
end
