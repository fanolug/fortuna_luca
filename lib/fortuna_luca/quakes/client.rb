# frozen_string_literal: true

require "httpclient"
require "nori"
require "ostruct"
require_relative "../redis/client"

module FortunaLuca
  module Quakes
    module Client
      include FortunaLuca::Redis::Client

      URL = "http://webservices.ingv.it/fdsnws/event/1/query"
      PAST_EVENT_IDS_KEY = "past_quake_event_ids"

      Event = Struct.new(
        "Event", :id, :url, :description, :time, :latitude, :longitude, :depth, :magnitude, keyword_init: true
      )

      # @params args Query arguments accepted by the web service
      #   See http://webservices.ingv.it/swagger-ui/dist/?url=https://ingv.github.io/openapi/fdsnws/event/0.0.1/event.yaml#/fdsnws-event-1.1/get_query for details
      # @return [Array<Event>] A list of events
      def quake_events(**args)
        response = HTTPClient.get(URL, args)
        result = Nori.new.parse(response.body)
        events = [result.dig("q:quakeml", "eventParameters", "event")].flatten

        events.compact.reverse.map do |event|
          id = event.dig("@publicID").split("eventId=").last
          next if past_event_ids.include?(id)

          redis.rpush(PAST_EVENT_IDS_KEY, id)
          Event.new(
            id: id,
            url: url(id),
            description: event.dig("description", "text"),
            time: event.dig("origin", "time", "value"),
            latitude: event.dig("origin", "latitude", "value"),
            longitude: event.dig("origin", "longitude", "value"),
            depth: event.dig("origin", "depth", "value"),
            magnitude: event.dig("magnitude", "mag", "value"),
          )
        end.compact
      end

      private

      def past_event_ids
        redis.lrange(PAST_EVENT_IDS_KEY, 0, -1)
      end

      def url(event_id)
        "http://terremoti.ingv.it/event/#{event_id}"
      end
    end
  end
end
