require_relative '../lib/fortuna_luca/quakes/client'
require_relative '../lib/fortuna_luca/telegram/quakes'

include FortunaLuca::Quakes::Client

task :send_last_quakes do
  time = (Time.now - (60 * 60)).strftime("%FT%T")

  events = quake_events(
    starttime: time,
    lat: 43.844109, # Fano
    lon: 13.017070,
    maxradiuskm: 250,
    minmag: 2
  )

  FortunaLuca::Telegram::Quakes.new(events).call
end
