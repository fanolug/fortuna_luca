require_relative "dialogflow_responder"
require_relative "../fortuna_luca/wikipedia/summary"
require_relative "../web_searcher"

module AI
  class TermSearchResponder
    include DialogflowResponder

    def call
      query = response.dig(:result, :parameters, :term)
      return if query.to_s == ""

      FortunaLuca::Wikipedia::Summary.new.call(query) ||
        WebSearcher.new(query: query, site: wikipedia_host).first_link
    end

    private

    def wikipedia_host
      "#{language}.wikipedia.org"
    end
  end
end
