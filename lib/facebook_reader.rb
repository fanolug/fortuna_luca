require 'koala'
require 'dotenv'
require 'date'

class FacebookReader
  attr_reader :facebook_page

  def initialize(facebook_page)
    Dotenv.load
    @graph = Koala::Facebook::API.new(ENV['FB_APP_TOKEN'])
    @facebook_page = facebook_page
  end

  def posts
    @graph.get_object("#{facebook_page}/posts?fields=full_picture,created_time,message&limit=5")
  end

  def post_for_the_last_hour(minutes)
    posts.take_while do |lastposts|
      Time.now - DateTime.parse(lastposts["created_time"]).to_time <= minutes * 60
    end
  end

  def picture_for_the_last_hour(minutes)
    post_for_the_last_hour(minutes).map {|post| post["full_picture"]}
      # end
  end

end

# puts FacebookReader.new('imemedelclimbersfigato').picture_for_the_last_hour(1440) #(minutes:1440) #.map {|ciao| ciao["full_picture"]}
