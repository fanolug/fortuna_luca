require "dotenv"
require "google/apis/customsearch_v1"

class WebSearcher
  def initialize(query)
    Dotenv.load
    @query = query
  end

  def first_link
    results = search_client.list_cses(
      @query,
      cx: ENV["GOOGLE_CUSTOM_SEARCH_ID"],
      num: 1
    )

    result = results.items.first
    result.link if result
  end

  private

  def search_client
    client = Google::Apis::CustomsearchV1::CustomsearchService.new
    client.key = ENV["GOOGLE_API_KEY"]
    client
  end
end
