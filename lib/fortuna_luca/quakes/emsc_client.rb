# frozen_string_literal: true

module FortunaLuca
  module Quakes
    class EMSCClient
      include FDSNClient

      private

      def extract_event_id(event)
        event.dig("@publicID").split("/event/").last
      end

      def webservice_url
        "https://seismicportal.eu"
      end

      def event_detail_url(event_id)
        "https://seismicportal.eu/eventdetails.html?unid=#{event_id}"
      end
    end
  end
end
