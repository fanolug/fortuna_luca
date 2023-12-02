require_relative "../../../../test/test_helper"

describe FortunaLuca::Reports::AllertaMeteo do
  let(:instance) { FortunaLuca::Reports::AllertaMeteo.new }
  let(:atom_feed) { File.read(File.dirname(__FILE__) + "/fixtures/allerta_meteo.xml") }
  let(:entries) { Feedjira.parse(atom_feed).entries }
  let(:redis_instance) { MockRedis.new }

  before do
    ENV["REPORTS_ALLERTA_METEO_CONFIG"] = '["12345"]'
    Redis.stubs(:new).returns(redis_instance)
  end

  describe '#call' do
    let(:expected_text) do
      <<-TEXT.chomp
⚠️ <b>Allerta 088/2023 valida dalle 12:00 del 02-12-2023: vento</b>
Per il pomeriggio odierno (sabato 2) sono previsti ancora venti intensi sud occidentali
      con velocitÃ media di vento moderato o teso e raffiche fino a burrasca forte o tempesta.
      L'intensitÃ del vento Ã¨ prevista in attenuazione dal tardo pomeriggio anche se le raffiche
      potranno ancora raggiungere il grado di vento forte o burrasca almeno fino alla serata quando,
      con la rotazione dei venti da nord ovest la loro intensitÃ diminuirÃ nelle zone collinari e
      montane mentre lungo la costa, seppure attenuata, sarÃ di vento moderato con raffiche fino a
      vento forte.
      Per la giornata di domenica saranno possibili brevi rovesci per nubi in ingresso dal mare piÃ¹
      probabili in mattinata nel settore centro settentrionale e nel primo pomeriggio in quello
      centro meridionale.
      Per la giornata di lunedÃ¬ dalla serata l'arrivo di una struttura a carattere caldo porterÃ
      deboli precipitazioni isolate nelle zone montane.
https://allertameteo.regione.marche.it/documents/20181/2282110/allerta088_2023.pdf
      TEXT
    end

    it "sends the latest alert, once" do
      FortunaLuca::Weather::AllertaMeteo::Client.any_instance.expects(:call).returns(entries)
      ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
        chat_id: "12345",
        text: expected_text,
        parse_mode: "HTML"
      )
      2.times { instance.call }
    end
  end
end
