require_relative "dialogflow_responder"

module AI
  class ComparisonResponder
    include DialogflowResponder

    def call
      subjects = result.parameters.fields["subjects"].list_value&.values&.map(&:string_value)&.uniq
      return if !subjects || subjects.size < 2
      subjects.sample
    end
  end
end
