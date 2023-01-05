# frozen_string_literal: true

require "geocoder/configuration"
require "geocoder/logger"
require "geocoder/kernel_logger"
require "geocoder/query"
require "geocoder/lookup"
require "geocoder/exceptions"

module FortunaLuca
  module Geo
    # @param location_name [String] A city name that can be geocoded
    # @return [Array] Latitude and longitude of ther location
    def coordinates_for(location_name)
      geocoder_init

      Geocoder::Query.new(location_name).
        execute.
        first&.
        coordinates
    end

    private

    def geocoder_init
      Geocoder.configure(timeout: 10)
    end
  end
end
