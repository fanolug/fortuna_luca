require_relative "../logging"

module AI
  class ComparisonResponder
    include Logging

    def initialize(apiai_response)
      @response = apiai_response
    end

    def call
      subjects = @response.dig(:result, :parameters, :subjects)
      return if !subjects || subjects.uniq.size < 2
      subjects&.uniq&.sample
    end
  end
end
