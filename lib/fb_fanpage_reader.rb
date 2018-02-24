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
    fanpageparse.css('.userContent').first.content do | usercontent |
      usercontent.css('p').content
    end
  end

  def lastpostimg
    fanpageparse.css('.mtm img').first['src']
  end

  def lastpost_timestamp
    fanpageparse.css('.livetimestamp').first['data-utime'].to_i
  end

end

require 'koala'
require 'dotenv'
require 'date'
require 'json'

class FbReader

  def initialize
    Dotenv.load
    @graph = Koala::Facebook::API.new('880327055470286|Djn38HaU79WAsYv7K1IM54JXpqs')
  end

  def posts
    ENV['FB_PAGES'].split(',').map(&:strip).map do | singlepagename |
      @graph.get_object("#{singlepagename}/posts?fields=full_picture,created_time,message&limit=5")[0..4]
    end
  end

  def postid
    posts.map do | pageposts |
      pageposts.map do | posts |
        posts["id"]
      end
    end
  end

  def post_created_at
    posts.map do | pageposts |
      pageposts.map do | posts |
        posts["created_time"]
      end
    end
  end

  def post_img
    posts.map do | pageposts |
      pageposts.map do | posts |
        posts["full_picture"]
      end
    end
  end

  def post_message
    posts.map do | pageposts |
      pageposts.map do | posts |
        posts["message"]
      end
    end
  end

  def post_for_the_last_hour(minutes: 60)
    posts.map do | pageposts |
      pageposts.take_while do | posts |
        # posts = Date.parse(posts["created_time"]).strftime("%s")
        Time.now.strftime("%s").to_i - DateTime.parse(posts["created_time"]).strftime("%s").to_i <= minutes * 60
        # posts.map do |picture|
        #   picture.map do |picture|
        #     picture["full_picture"] #.map {|ciao| ciao["full_picture"]}
        #   end
        # end
      end
    end
  end

  def picture_for_the_last_hour
    post_for_the_last_hour.map {|pictures| pictures.map do | picture |
      picture["full_picture"]
    end
    }
  end


end


# puts FbReader.new.postid.map {|ciao| ciao[0]}
# puts FbReader.new.posts
# puts FbReader.new.post_created_at.map { |created_at| created_at.map { | parse | Date.parse(parse).strftime("%s").to_i} }
# puts FbReader.new.post_img
# puts FbReader.new.post_message
# puts FbReader.new.post_for_the_last_minutes(minutes: 1440) #.map {|ciao| ciao.map {|ciao| ciao["full_picture"]} }
puts FbReader.new.picture_for_the_last_hour #(minutes:1440) #.map {|ciao| ciao["full_picture"]}

def send_meme_climbers
    if FbFanpageReader.new.lastpost_timestamp >= Time.now.strftime('%s').to_i - 3600
      send_message(ENV['OUG_CHAT_ID'], "#{FbFanpageReader.new.lastposttext} #{FbFanpageReader.new.lastpostimg}")
    end
end

