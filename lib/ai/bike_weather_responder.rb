require_relative "weather_responder"

module AI
  class BikeWeatherResponder < WeatherResponder
    def call
      response = case forecaster.ok_for_bike?
        when true then "fa"
        when false then "non fa"
        else return "non lo so se fa"
      end

      [
        time_in_words,
        "a #{weather_city}",
        "#{response} uscire in bici"
      ].compact.join(" ")
    end
  end
end
