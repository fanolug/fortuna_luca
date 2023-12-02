require_relative "../../../../../test/test_helper"

describe FortunaLuca::Telegram::Wikipedia::OnThisDay do
  let(:instance) do
    FortunaLuca::Telegram::Wikipedia::OnThisDay.new(
      language: "it",
      month: "09",
      day: "20",
      type: "selected"
    )
  end
  let(:stubbed_response) do
    File.read(File.dirname(__FILE__) + '/../../../wikipedia/test/fixtures/wikipedia_on_this_day.json')
  end

  before do
    FortunaLuca::Wikipedia::OnThisDay.any_instance.expects(:call).returns(
      JSON.parse(stubbed_response)["selected"]
    )
  end

  describe "#call" do
    let(:expected_result) do
      <<~TEXT.chomp
      <b>Accadde oggi 20/09...</b>
      <i>1302</i>: Finisce la <a href=\"https://it.wikipedia.org/wiki/Guerra_tra_Genova%2C_Bisanzio_e_Venezia\">Guerra tra Genova, Bisanzio e Venezia</a>.
      <i>1582</i>: <a href=\"https://it.wikipedia.org/wiki/Papa_Gregorio_XIII\">Papa Gregorio XIII</a> introduce il <a href=\"https://it.wikipedia.org/wiki/Calendario_gregoriano\">Calendario gregoriano</a>.
      <i>1830</i>: Viene creato, dopo la separazione dai <a href=\"https://it.wikipedia.org/wiki/Paesi_Bassi\">Paesi Bassi</a>, lo stato del <a href=\"https://it.wikipedia.org/wiki/Belgio\">Belgio</a>.
      <i>1957</i>: Viene lanciato lo <a href=\"https://it.wikipedia.org/wiki/Sputnik_1\">Sputnik 1</a>, il primo <a href=\"https://it.wikipedia.org/wiki/Satellite_artificiale\">Satellite artificiale</a> a orbitare intorno alla <a href=\"https://it.wikipedia.org/wiki/Terra\">Terra</a>.
      <i>1965</i>: <a href=\"https://it.wikipedia.org/wiki/Papa_Paolo_VI\">Papa Paolo VI</a> è il primo Papa a fare visita ufficiale negli Stati Uniti.
      TEXT
    end

    it "sends the formatted Telegram message" do
      ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
        chat_id: "12345",
        text: expected_result,
        parse_mode: 'HTML',
        disable_web_page_preview: true,
        disable_notification: true
      )
      instance.call
    end
  end
end
