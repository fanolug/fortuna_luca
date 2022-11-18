require_relative "../../../../test/test_helper"
require_relative "../summary"

describe FortunaLuca::Wikipedia::Summary do
  let(:instance) { FortunaLuca::Wikipedia::Summary.new("it") }
  let(:stubbed_response) { HTTP::Message.new_response(data) }

  describe "#call" do
    before do
      HTTPClient.stubs(:get).with(
        "https://it.wikipedia.org/w/api.php",
        kind_of(Hash)
      ).returns(stubbed_response)
    end

    describe "with valid data returned" do
      let(:data) do
        File.read(File.dirname(__FILE__) + '/fixtures/wikipedia_linux.json')
      end

      it "returns the Wikipedia summary" do
        instance.call("linux").must_equal(
          "Linux (/ˈlinuks/, pronuncia inglese [ˈlɪnʊks]) è una famiglia di sistemi operativi di tipo Unix-like, pubblicati in varie distribuzioni, aventi la caratteristica comune di utilizzare come nucleo il kernel Linux: oggi molte importanti società nel campo dell'informatica come Google, IBM, Oracle Corporation, Hewlett-Packard, Red Hat, Canonical, Novell e Valve sviluppano e pubblicano sistemi Linux."
        )
      end
    end

    describe "with invalid JSON data returned" do
      let(:data) { "" }

      it "returns nil" do
        instance.call("linux").must_equal(nil)
      end
    end

    describe "with blank data returned" do
      let(:data) { '{"batchcomplete":""}' }

      it "returns nil" do
        instance.call("linux").must_equal(nil)
      end
    end
  end
end
