require "dotenv/load"
require_relative "../config/i18n"
require "zeitwerk"

module FortunaLuca
end

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "ai" => "AI",
  "chat_gpt" => "ChatGPT",
  "chat_gpt_client" => "ChatGPTClient",
  "emsc_client" => "EMSCClient",
  "ingv_client" => "INGVClient",
  "tomorrow_io" => "TomorrowIO",
  "open_ai" => "OpenAI",
  "processed_ids" => "ProcessedIDs",
)
tests = "#{__dir__}/**/test/*"
loader.ignore(tests)
loader.setup
loader.eager_load if ENV["RACK_ENV"]
