require "api-ai-ruby"

module ApiaiClient
  private

  def apiai_client
    @apiai_client ||= ApiAiRuby::Client.new(
      client_access_token: ENV["APIAI_TOKEN"],
      api_lang: "IT"
    )
  end
end
