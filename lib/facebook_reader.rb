require 'koala'
require 'dotenv'
require 'date'

class FacebookReader

  def initialize
    Dotenv.load
    @graph = Koala::Facebook::API.new(ENV['FB_APP_TOKEN'])
  end

  def posts
    ENV['FB_PAGES'].split(',').map(&:strip).map do |pagename|
      @graph.get_object("#{pagename}/posts?fields=full_picture,created_time,message&limit=5")
    end
  end

  def post_for_the_last_hour(minutes: 60)
    posts.map do |pageposts|
      pageposts.take_while do |posts|
        Time.now - DateTime.parse(posts["created_time"]).to_time <= minutes * 60
      end
    end
  end

  def picture_for_the_last_hour
    post_for_the_last_hour.map {|posts| posts.map do |picture|
        picture["full_picture"]
      end
    }
  end

end

# puts FacebookReader.new.picture_for_the_last_hour #(minutes:1440) #.map {|ciao| ciao["full_picture"]}
