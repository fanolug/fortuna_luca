require_relative "base"
require_relative "../../wikipedia/summary"
require_relative "../../web_searcher"

module FortunaLuca
  module AI
    module Responders
      class TermSearch < Base
        def call
          query = result.parameters.fields["term"].string_value
          return if query.to_s == ""

          FortunaLuca::Wikipedia::Summary.new.call(query) ||
            FortunaLuca::WebSearcher.new(query: query, site: wikipedia_host).first_link
        end

        private

        def wikipedia_host
          "#{language}.wikipedia.org"
        end
      end
    end
  end
end
