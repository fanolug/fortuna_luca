require_relative "dialogflow_responder"
require_relative "../fortuna_luca/wikipedia/summary"

module AI
  class TermSearchResponder
    include DialogflowResponder

    def call
      query = response.dig(:result, :parameters, :term)
      return if query.to_s == ""

      FortunaLuca::Wikipedia::Summary.new.call(query)
    end
  end
end
