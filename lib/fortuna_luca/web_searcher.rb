require "dotenv/load"
require "google/apis/customsearch_v1"
require_relative "logging"

module FortunaLuca
  class WebSearcher
    include Logging

    def initialize(query:, site: nil)
      @query = query
      @site = site
    end

    def first_link
      result = search_client.list_cses(
        exact_terms: query,
        cx: ENV["GOOGLE_CUSTOM_SEARCH_ID"],
        site_search: site,
        num: 1
      )

      logger.info(result)
      result.items&.first&.link
    end

    private

    attr_reader :query, :site

    def search_client
      client = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
      client.key = ENV["GOOGLE_API_KEY"]
      client
    end
  end
end
