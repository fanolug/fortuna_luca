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
      <i>1519</i>: <a href='https://it.wikipedia.org/wiki/Ferdinando_Magellano'>Ferdinando Magellano</a> inizia il suo viaggio intorno al mondo.
      <i>1870</i>: I <a href='https://it.wikipedia.org/wiki/Bersaglieri'>Bersaglieri</a> entrano a <a href='https://it.wikipedia.org/wiki/Roma'>Roma</a> attraverso la breccia di Porta Pia. Termina il <a href='https://it.wikipedia.org/wiki/Potere_temporale'>Potere temporale</a> dei papi.
      <i>1946</i>: Si tiene la prima edizione del <a href='https://it.wikipedia.org/wiki/Festival_di_Cannes'>Festival di Cannes</a>.
      <i>1958</i>: Entra in vigore la <a href='https://it.wikipedia.org/wiki/Legge_Merlin'>Legge Merlin</a> per regolamentare la <a href='https://it.wikipedia.org/wiki/Prostituzione'>Prostituzione</a> in <a href='https://it.wikipedia.org/wiki/Italia'>Italia</a>.
      <i>1979</i>: L'imperatore Bokassa I viene rovesciato da un <a href='https://it.wikipedia.org/wiki/Colpo_di_Stato'>Colpo di Stato</a>.
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
