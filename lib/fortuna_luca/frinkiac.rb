require 'frinkiac'
require_relative "../logging"

module FortunaLuca
  class Frinkiac
    include Logging

    def search_image(term)
      result = ::Frinkiac::Screencap.random(term)
      return unless result
      "#{result.caption} #{result.image_url}"
    end
  end
end
