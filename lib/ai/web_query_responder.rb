require_relative "../logging"
require_relative "../web_searcher"

module AI
  class WebQueryResponder
    include Logging

    def initialize(apiai_response)
      @response = apiai_response
    end

    def call
      query = @response.dig(:result, :parameters, :query)
      return if query.to_s == ""

      WebSearcher.new(query).first_link
    end
  end
end
