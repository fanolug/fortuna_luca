require_relative "dialogflow_responder"
require_relative "../fortuna_luca/frinkiac"
require_relative "../web_searcher"

module AI
  class SimpsonsSearchResponder
    include DialogflowResponder

    def call
      query = response.dig(:result, :parameters, :term)
      return if query.to_s == ""

      FortunaLuca::Frinkiac.new.search_image(query)
    end
  end
end
