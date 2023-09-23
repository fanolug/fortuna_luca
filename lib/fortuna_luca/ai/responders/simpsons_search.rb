module FortunaLuca
  module AI
    module Responders
      class SimpsonsSearch < Base

        def call
          query = result.parameters.fields["term"].string_value
          return if query.to_s == ""

          FortunaLuca::Frinkiac.new.search_image(query)
        end
      end
    end
  end
end
