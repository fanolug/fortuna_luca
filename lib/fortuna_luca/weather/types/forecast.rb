# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

module FortunaLuca
  module Weather
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
    end
  end
end
