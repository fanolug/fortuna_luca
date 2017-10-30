module ApiaiResponses
  def simple_apiai_response
    {
      id: "93ae6b04-9f27-496d-a135-1863384fad4c",
      timestamp: "2017-09-27T19:14:04.693Z",
      lang: "it",
      result: {
        source: "agent",
        resolvedQuery: "ciao!",
        action: "input.welcome",
        actionIncomplete: false,
        parameters: {},
        contexts: [],
        metadata: {
          intentId: "bbb7cc04-07e4-4a4c-9609-777a50246962",
          webhookUsed: "false",
          webhookForSlotFillingUsed: "false",
          intentName: "Default Welcome Intent"
        },
        fulfillment: {
          speech: "Cià",
          messages: [
            {
              type: 0,
              speech: "Buongiorno"
            }
          ]
        },
        score: 0.47999998927116394
      },
      status: {
        code: 200,
        errorType: "success"
      },
      sessionId: "63117d74-0a53-4083-b6d3-841658f8ae4b"
    }
  end

  def weather_apiai_response
    {
      id: "2557adc1-d773-41d9-bffa-7ca73fdc14f9",
      timestamp: "2017-09-27T19:23:45.605Z",
      lang: "it",
      result: {
        source: "agent",
        resolvedQuery: "che tempo fa domani a Fano?",
        action: "weather",
        actionIncomplete: false,
        parameters: {
          address: {
            city: "Fano"
          },
          :"date-time"=>"2017-09-28"
        },
        contexts: [
          {
            name: "weather",
            parameters: {
              :"date-time.original"=>"domani",
              address: {
                city: "Fano",
                :"city.original"=>"Fano"
              },
              :"date-time"=>"2017-09-28",
              :"address.original"=>"Fano"
            },
            lifespan: 2
          }
        ],
        metadata: {
          intentId: "f1b75ecb-a35f-4a26-88fb-5a8049b92b02",
          webhookUsed: "false",
          webhookForSlotFillingUsed: "false",
          intentName: "weather"
        },
        fulfillment: {
          speech: "",
          messages: [
            {
              type: 0,
              speech: ""
            }
          ]
        },
        score: 0.9599999785423279
      },
      status: {
        code: 200,
        errorType: "success"
      },
      sessionId: "e49c9861-befb-4c57-9f95-26c72422ff4a"
    }
  end

  def web_query_apiai_response
    {
      id: "101ae06a-afa9-4d10-889d-c6a5d1196193",
      timestamp: "2017-09-27T19:31:24.881Z",
      lang: "it",
      result: {
        source: "agent",
        resolvedQuery: "cerca fanolug",
        action: "web_query",
        actionIncomplete: false,
        parameters: {
          query: "fanolug"
        },
        contexts: [],
        metadata: {
          intentId: "c0eb4973-d656-4aeb-b0cf-a70bc429f19a",
          webhookUsed: "false",
          webhookForSlotFillingUsed: "false",
          intentName: "web search"
        },
        fulfillment: {
          speech: "",
          messages: [
            {
              type: 0,
              speech: ""
            }
          ]
        },
        score: 1.0
      },
      status: {
        code: 200,
        errorType: "success"
      },
      sessionId: "a611afa8-e989-42f1-adb4-0e6dd8f24dd4"
    }
  end

  def comparison_apiai_response(subjects: ["linux", "windows"])
    {
      id: "48b50c0e-dc20-43b9-b152-b6698768a96f",
      timestamp: "2017-09-27T19:44:59.986Z",
      lang: "it",
      result: {
        source: "agent",
        resolvedQuery: "è meglio linux o windows?",
        action: "comparison",
        actionIncomplete: false,
        parameters: {
          subjects: subjects
        },
        contexts: [],
        metadata: {
          intentId: "66da1a59-58b5-4db1-978f-6188beb15779",
          webhookUsed: "false",
          webhookForSlotFillingUsed: "false",
          intentName: "Comparison"
        },
        fulfillment: {
          speech: "",
          messages: [
            {
              type: 0,
              speech: ""
            }
          ]
        },
        score: 0.8500000238418579
      },
      status: {
        code: 200,
        errorType: "success"
      },
      sessionId: "d6c995c3-80cb-47c1-967f-f2537893fb52"
    }
  end
end
