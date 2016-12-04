require "open-uri"
require "json"

class Xkcd
  def random_image
    last_comic_num = JSON.parse(open("http://xkcd.com/info.0.json").read)["num"]
    comic_num = rand(1..last_comic_num)
    comic_num = rand(1..403) if comic_num == 404 # lol
    comic_data = comic_data(comic_num)

    "#{comic_data['alt']}: #{comic_data['img']}"
  end

  private

  def comic_data(comic_num)
    JSON.parse(open("http://xkcd.com/#{comic_num}/info.0.json").read)
  end
end
