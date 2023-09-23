# frozen_string_literal: true

module FortunaLuca
  module Quakes
    class INGVClient
      include FDSNClient

      private

      def extract_event_id(event)
        event.dig("@publicID").split("eventId=").last
      end

      def webservice_url
        "http://webservices.ingv.it"
      end

      def webservice_path
        "/fdsnws/event/1/query"
      end

      def event_detail_url(event_id)
        "http://terremoti.ingv.it/event/#{event_id}"
      end
    end
  end
end
