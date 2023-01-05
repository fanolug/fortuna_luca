FortunaLuca::Weather::Result = Struct.new(
  "Result",
  :success, # true
  :error, # "an error"
  :text_summary, # "pioggia leggera"
  :precipitations, # { probability: 88 (%), rain: 2 (mm), snow: 0 (mm) }
  :temperatures, # { min: 10 (°C), max: 14 (°C) }
  :wind, # { speed: 10 (m/s), deg: 260 (°), gust: 16 (m/s) }
  :pressure, # 1005
  :humidity, # 60 (%)
  :icons, # ["🌧"]
  keyword_init: true
)
