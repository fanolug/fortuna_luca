require_relative "../logging"

module AI
  class ComparisonResponder
    include Logging

    def initialize(apiai_response)
      @response = apiai_response
    end

    def call
      subjects = @response.dig(:result, :parameters, :subjects)
      subjects&.uniq&.sample
    end
  end
end
