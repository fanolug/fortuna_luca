require 'nokogiri'
require 'dotenv'
require 'open-uri'

class FbFanpageReader
  def initialize
    Dotenv.load
  end

  def fanpageurl
    "#{ENV['FANPAGE_URL']}"
  end

  def fanpageparse
    Nokogiri::XML(open("#{fanpageurl}"))
  end

  def lastposttext
    fanpageparse.css('.userContent p').first
  end

  def lastpostimg
    fanpageparse.css('.mtm img').first['src']
  end

  def lastpost_timestamp
    fanpageparse.css('.livetimestamp').first['data-utime'].to_i
  end

end
