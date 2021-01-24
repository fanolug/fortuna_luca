require_relative "weather_responder"

module AI
  class BikeWeatherResponder < WeatherResponder
    def call
      good_hours = forecaster.good_bike_hours
      if good_hours.none?
        return "#{time_in_words} a #{weather_city} non fa uscire in bici"
      end

      grouped_good_hours = good_hours.sort.slice_when do |previous, current|
        previous.next != current
      end.to_a

      good_hours_in_words = grouped_good_hours.map.with_index(1) do |group, index|
        group = [group].flatten
        "tra le #{group.first} e le #{group.last.next}"
      end.join(", ")

      [
        time_in_words,
        "a #{weather_city}",
        "fa uscire in bici",
        good_hours_in_words
      ].compact.join(" ")
    end
  end
end
