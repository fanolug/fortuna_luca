# frozen_string_literal: true

require "httpclient"
require "feedjira"

module FortunaLuca
  module Weather
    module AllertaMeteo
      class Client
        URL = "https://allertameteo.regione.marche.it/compila-allerta-portlet/feed?feed=allerte-bollettini"

        # @return [Array<Feedjira::Parser::AtomEntry>] The feed entries
        def call
          data = HTTPClient.get(URL).body
          Feedjira.parse(data).entries
        end
      end
    end
  end
end
