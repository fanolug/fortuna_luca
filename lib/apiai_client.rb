require "api-ai-ruby"

module ApiaiClient
  def ai_response_to(text)
    begin
      result = apiai_client.text_request(text)
      result[:result][:fulfillment][:speech]
    rescue ApiAiRuby::ClientError, ApiAiRuby::RequestError => e
      e.message
    end
  end

  private

  def apiai_client
    @apiai_client ||= ApiAiRuby::Client.new(
      client_access_token: ENV["APIAI_TOKEN"],
      api_lang: ENV["APIAI_LANG"]
    )
  end
end
