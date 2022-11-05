require_relative "../test_helper"
require_relative "../../lib/fortuna_luca/xkcd"

describe FortunaLuca::Xkcd do
  let(:instance) { FortunaLuca::Xkcd.new }

  describe '#random_image' do
    let(:index_response) { '{"num": 2231}' }
    let(:detail_response) { '{"alt": "the alt", "img": "http://img.example.com"}' }

    before do
      stub_request(:get, "https://xkcd.com/info.0.json").to_return(body: index_response)
      stub_request(:get, %r{https://xkcd.com/\d+/info.0.json}).to_return(body: detail_response)
    end

    it 'returns the correct data' do
      instance.random_image.must_equal("the alt: http://img.example.com")
    end
  end
end
