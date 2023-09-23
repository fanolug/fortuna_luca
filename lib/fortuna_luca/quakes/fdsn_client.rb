# frozen_string_literal: true

require "faraday"
require "nori"
require "ostruct"

module FortunaLuca
  module Quakes
    # Client for FDSN Web Services: http://www.fdsn.org/webservices/
    module FDSNClient
      include FortunaLuca::ProcessedIDs
      include Logging

      Event = Struct.new(
        "Event", :id, :url, :description, :time, :latitude, :longitude, :depth, :magnitude, keyword_init: true
      )

      # @params params Query arguments accepted by the web service
      # @return [Array<Event>] A list of events
      def call(**params)
        connection = Faraday.new(url: webservice_url, params: params)
        response = connection.get(webservice_path)
        logger.info(response.body)
        result = Nori.new.parse(response.body)
        events = extract_events(result)

        parse_events(events)
      end

      private

      def processed_ids_redis_key
        "processed_quake_event_ids"
      end

      def extract_events(result)
        [result.dig("q:quakeml", "eventParameters", "event")].flatten
      end

      def parse_events(events)
        events.compact.reverse.map do |event|
          id = extract_event_id(event)
          next unless process_id!(id)

          build_event(id, event)
        end.compact
      end

      def build_event(event_id, event)
        Event.new(
          id: event_id,
          url: event_detail_url(event_id),
          description: event.dig("description", "text"),
          time: event.dig("origin", "time", "value"),
          latitude: event.dig("origin", "latitude", "value"),
          longitude: event.dig("origin", "longitude", "value"),
          depth: event.dig("origin", "depth", "value"),
          magnitude: event.dig("magnitude", "mag", "value"),
        )
      end

      def extract_event_id(event)
        raise NotImplementedError
      end

      def webservice_url
        raise NotImplementedError
      end

      def webservice_path
        "/fdsnws/event/1/query"
      end

      def event_detail_url(event_id)
        raise NotImplementedError
      end
    end
  end
end
