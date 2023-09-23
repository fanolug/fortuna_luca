# frozen_string_literal: true

require 'dry-struct'

module FortunaLuca
  module Weather
    module Types
      include Dry.Types()

      class Precipitations < Dry::Struct
        attribute :probability, Types::Strict::Integer # %
        attribute :rain, Types::Strict::Integer # mm
        attribute :snow, Types::Strict::Integer # mm
      end

      class Temperatures < Dry::Struct
        attribute :min, Types::Strict::Integer # °C
        attribute :max, Types::Strict::Integer # °C
      end

      class Wind < Dry::Struct
        attribute :speed, Types::Strict::Integer # m/s
        attribute :deg, Types::Strict::Integer # °
        attribute :gust, Types::Strict::Integer # m/s
      end

      class Detail < Dry::Struct
        attribute :time, Types::Strict::Integer # unix epoch
        attribute :codes, Types::Strict::Array.of(Types::Strict::Symbol)
        attribute :text_summary, Types::Strict::String.optional.default(nil)
        attribute :precipitations, Precipitations
        attribute :temperatures, Temperatures
        attribute :wind, Wind
        attribute :pressure, Types::Strict::Integer # hPa
        attribute :humidity, Types::Strict::Integer # %
      end

      class Forecast < Dry::Struct
        attribute :success, Types::Strict::Bool
        attribute :error, Types::Strict::String.optional.default(nil)
        attribute :daily, Detail
        attribute :hourly, Types::Strict::Array.of(Detail)
      end
    end
  end
end
