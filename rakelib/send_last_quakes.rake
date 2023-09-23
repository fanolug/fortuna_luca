task :send_last_quakes do
  start_time = (Time.now - (60 * 60)).strftime("%FT%T")

  events = FortunaLuca::Quakes::INGVClient.new.call(
    starttime: start_time,
    lat: 43.844109, # Fano
    lon: 13.017070,
    maxradius: 2.5, # 1 = ~110km
    minmag: 3
  )

  FortunaLuca::Telegram::Quakes.new(events).call
end
