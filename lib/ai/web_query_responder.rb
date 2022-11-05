require_relative "dialogflow_responder"
require_relative "../fortuna_luca/web_searcher"

module AI
  class WebQueryResponder
    include DialogflowResponder

    def call
      query = result.parameters.fields["query"].string_value
      return if query.to_s == ""

      FortunaLuca::WebSearcher.new(query: query).first_link
    end
  end
end
