require "google/apis/customsearch_v1"

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
      if result.items&.any?
        result.items.first.link
      elsif @query = result.spelling&.corrected_query
        first_link
      end
    end

    private

    attr_accessor :query
    attr_reader :site

    def search_client
      client = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
      client.key = ENV["GOOGLE_API_KEY"]
      client
    end
  end
end
