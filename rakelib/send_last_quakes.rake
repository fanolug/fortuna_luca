require_relative '../lib/fortuna_luca/quakes/client'
require_relative '../lib/fortuna_luca/telegram/quakes'

include FortunaLuca::Quakes::Client

task :send_last_quakes do
  time = (Time.now(in: "+01:00") - (60 * 60 * 12)).strftime("%FT%T")

  events = quake_events(
    starttime: time,
    lat: 43.84410946691423,
    lon: 13.01707095294847,
    maxradiuskm: 100,
    minmag: 3
  )

  FortunaLuca::Telegram::Quakes.new(events).call
end
