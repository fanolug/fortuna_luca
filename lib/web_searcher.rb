require "dotenv"
require "google/apis/customsearch_v1"

class WebSearcher
  def initialize(query)
    Dotenv.load
    @query = query
  end

  def first_link
    result = search_client.list_cses(
      @query,
      cx: ENV["GOOGLE_CUSTOM_SEARCH_ID"],
      num: 1
    )

    result.items&.first&.link
  end

  private

  def search_client
    client = Google::Apis::CustomsearchV1::CustomsearchService.new
    client.key = ENV["GOOGLE_API_KEY"]
    client
  end
end
