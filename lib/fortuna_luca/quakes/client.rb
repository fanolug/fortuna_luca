require "faraday"
require "nori"
require "ostruct"

module FortunaLuca
  module Quakes
    module Client
      URL = "http://webservices.ingv.it/fdsnws/event/1/query"

      Event = Struct.new(
        'Event', :id, :url, :description, :time, :latitude, :longitude, :depth, :magnitude, keyword_init: true
      )

      # @params args Query arguments accepted by the web service
      #   See http://webservices.ingv.it/swagger-ui/dist/?url=https://ingv.github.io/openapi/fdsnws/event/0.0.1/event.yaml#/fdsnws-event-1.1/get_query for details
      # @return [Array<Event>] A list of events
      def quake_events(**args)
        response = Faraday.get(URL, args)
        result = Nori.new.parse(response.body)
        events = result.dig("q:quakeml", "eventParameters", "event")
        return [] unless events

        events.map do |event|
          id = event.dig("@publicID").split("eventId=").last

          Event.new(
            id: id,
            url: "http://terremoti.ingv.it/event/#{id}",
            description: event.dig("description", "text"),
            time: event.dig("origin", "time", "value"),
            latitude: event.dig("origin", "latitude", "value"),
            longitude: event.dig("origin", "longitude", "value"),
            depth: event.dig("origin", "depth", "value"),
            magnitude: event.dig("magnitude", "mag", "value"),
          )
        end
      end
    end
  end
end
