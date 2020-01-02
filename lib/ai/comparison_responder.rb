require_relative "dialogflow_responder"

module AI
  class ComparisonResponder
    include DialogflowResponder

    def call
      subjects = response.dig(:result, :parameters, :subjects)
      return if !subjects || subjects.uniq.size < 2
      subjects.uniq.sample
    end
  end
end
