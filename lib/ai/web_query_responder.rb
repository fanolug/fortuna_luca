require_relative "dialogflow_responder"
require_relative "../web_searcher"

module AI
  class WebQueryResponder
    include DialogflowResponder

    def call
      query = result.parameters.fields["query"].string_value
      return if query.to_s == ""

      WebSearcher.new(query: query).first_link
    end
  end
end
