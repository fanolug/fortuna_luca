module FortunaLuca
  module AI
    module Responders
      class WebQuery < Base
        def call
          query = result.parameters.fields["query"].string_value
          return if query.to_s == ""

          FortunaLuca::WebSearcher.new(query: query).first_link
        end
      end
    end
  end
end
