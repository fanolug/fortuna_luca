require_relative "dialogflow_responder"
require_relative "../web_searcher"

module AI
  class WebQueryResponder
    include DialogflowResponder

    def call
      query = response.dig(:result, :parameters, :query)
      return if query.to_s == ""

      WebSearcher.new(query: query).first_link
    end
  end
end
