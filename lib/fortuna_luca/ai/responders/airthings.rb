module FortunaLuca
  module AI
    module Responders
      class Airthings < Base
        include FortunaLuca::Airthings::Status

        def initialize; end

        def call
          airthings_status
        end
      end
    end
  end
end
