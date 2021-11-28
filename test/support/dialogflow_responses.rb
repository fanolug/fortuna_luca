# frozen_string_literal: true

require "google/cloud/dialogflow/v2"

module DialogflowResponses
  def direct_response
    Google::Cloud::Dialogflow::V2::DetectIntentResponse.new(
      response_id: "e90a1e7d-5a24-4d60-942b-c92c2536683b-0c9356c1",
      query_result: Google::Cloud::Dialogflow::V2::QueryResult.new(
        query_text: "ciao",
        language_code: "it",
        speech_recognition_confidence: 0.0,
        action: "input.welcome",
        parameters: Google::Protobuf::Struct.new,
        all_required_params_present: true,
        cancels_slot_filling: false,
        fulfillment_text: "Buongiorno",
        fulfillment_messages: [
          Google::Cloud::Dialogflow::V2::Intent::Message.new(
            platform: :PLATFORM_UNSPECIFIED,
            text: Google::Cloud::Dialogflow::V2::Intent::Message::Text.new(
             text: ["Buongiorno"]
            )
          )
        ],
        webhook_source: "",
        output_contexts: [],
        intent: Google::Cloud::Dialogflow::V2::Intent.new(
          name: "projects/italian-guy-telegram-bot/agent/intents/bbb7cc04-07e4-4a4c-9609-777a50246962",
          display_name: "Default Welcome Intent",
          webhook_state: :WEBHOOK_STATE_UNSPECIFIED,
          priority: 0,
          is_fallback: false,
          ml_disabled: false,
          live_agent_handoff: false,
          end_interaction: false,
          input_context_names: [],
          events: [],
          training_phrases: [],
          action: "",
          output_contexts: [],
          reset_contexts: false,
          parameters: [],
          messages: [],
          default_response_platforms: [],
          root_followup_intent_name: "",
          parent_followup_intent_name: "",
          followup_intent_info: []
        ),
        intent_detection_confidence: 1.0
      ),
      output_audio: ""
    )
  end

  def comparison_response(subjects:)
    Google::Cloud::Dialogflow::V2::QueryResult.new(
      query_text: "è meglio linux o windows?",
      language_code: "it",
      speech_recognition_confidence: 0.0,
      action: "comparison",
      parameters: Google::Protobuf::Struct.new(
        fields: {
          "subjects"=>Google::Protobuf::Value.new(
            list_value: Google::Protobuf::ListValue.new(
              values: subjects&.map do |subject|
                Google::Protobuf::Value.new(
                  string_value: subject
                )
              end
            )
          )
        }
      ),
      all_required_params_present: true,
      cancels_slot_filling: false,
      fulfillment_text: "",
      fulfillment_messages: [
        Google::Cloud::Dialogflow::V2::Intent::Message.new(
          platform: :PLATFORM_UNSPECIFIED,
          text: Google::Cloud::Dialogflow::V2::Intent::Message::Text.new(
            text: [""]
          )
        )
      ],
      webhook_source: "",
      output_contexts: [],
      intent: Google::Cloud::Dialogflow::V2::Intent.new(
        name: "projects/italian-guy-telegram-bot/agent/intents/66da1a59-58b5-4db1-978f-6188beb15779",
        display_name: "Comparison",
        webhook_state: :WEBHOOK_STATE_UNSPECIFIED,
        priority: 0,
        is_fallback: false,
        ml_disabled: false,
        live_agent_handoff: false,
        end_interaction: false,
        input_context_names: [],
        events: [],
        training_phrases: [],
        action: "",
        output_contexts: [],
        reset_contexts: false,
        parameters: [],
        messages: [],
        default_response_platforms: [],
        root_followup_intent_name: "",
        parent_followup_intent_name: "",
        followup_intent_info: []
      ),
      intent_detection_confidence: 1.0
    )
  end

  def term_search_response(query:)
    Google::Cloud::Dialogflow::V2::QueryResult.new(
      query_text: "cos'è #{query}",
      language_code: "it",
      speech_recognition_confidence: 0.0,
      action: "term_search",
      parameters: Google::Protobuf::Struct.new(
        fields: {
          "term"=>Google::Protobuf::Value.new(
            string_value: query
          )
        }
      ),
      all_required_params_present: true,
      cancels_slot_filling: false,
      fulfillment_text: "",
      fulfillment_messages: [
        Google::Cloud::Dialogflow::V2::Intent::Message.new(
          platform: :PLATFORM_UNSPECIFIED,
          text: Google::Cloud::Dialogflow::V2::Intent::Message::Text.new(
            text: [""]
          )
        )
      ],
      webhook_source: "",
      output_contexts: [],
      intent: Google::Cloud::Dialogflow::V2::Intent.new(
        name: "projects/italian-guy-telegram-bot/agent/intents/113fe095-2b2d-4e3c-a3a2-7baed36553b6",
        display_name: "Term search",
        webhook_state: :WEBHOOK_STATE_UNSPECIFIED,
        priority: 0,
        is_fallback: false,
        ml_disabled: false,
        live_agent_handoff: false,
        end_interaction: false,
        input_context_names: [],
        events: [],
        training_phrases: [],
        action: "",
        output_contexts: [],
        reset_contexts: false,
        parameters: [],
        messages: [],
        default_response_platforms: [],
        root_followup_intent_name: "",
        parent_followup_intent_name: "",
        followup_intent_info: []
      ),
      intent_detection_confidence: 1.0
    )
  end

  def web_query_response(query:)
    Google::Cloud::Dialogflow::V2::QueryResult.new(
      query_text: "cerca #{query}",
      language_code: "it",
      speech_recognition_confidence: 0.0,
      action: "web_query",
      parameters: Google::Protobuf::Struct.new(
        fields: {
          "query"=>Google::Protobuf::Value.new(
            string_value: "result for #{query}"
          )
        }
      ),
      all_required_params_present: true,
      cancels_slot_filling: false,
      fulfillment_text: "",
      fulfillment_messages: [
        Google::Cloud::Dialogflow::V2::Intent::Message.new(
          platform: :PLATFORM_UNSPECIFIED,
          text: Google::Cloud::Dialogflow::V2::Intent::Message::Text.new(
            text: [""]
          )
        )
      ],
      webhook_source: "",
      output_contexts: [],
      intent: Google::Cloud::Dialogflow::V2::Intent.new(
        name: "projects/italian-guy-telegram-bot/agent/intents/c0eb4973-d656-4aeb-b0cf-a70bc429f19a",
        display_name: "web search",
        webhook_state: :WEBHOOK_STATE_UNSPECIFIED,
        priority: 0,
        is_fallback: false,
        ml_disabled: false,
        live_agent_handoff: false,
        end_interaction: false,
        input_context_names: [],
        events: [],
        training_phrases: [],
        action: "",
        output_contexts: [],
        reset_contexts: false,
        parameters: [],
        messages: [],
        default_response_platforms: [],
        root_followup_intent_name: "",
        parent_followup_intent_name: "",
        followup_intent_info: []
      ),
      intent_detection_confidence: 1.0
    )
  end

  def weather_response
    Google::Cloud::Dialogflow::V2::QueryResult.new(
      query_text: "che tempo fa domani a Fano?",
      language_code: "it",
      speech_recognition_confidence: 0.0,
      action: "weather",
      parameters: Google::Protobuf::Struct.new(
        fields: {
          "address"=>Google::Protobuf::Value.new(
            struct_value: Google::Protobuf::Struct.new(
              fields: {
                "island"=>Google::Protobuf::Value.new(
                  string_value: ""
                ),
                  "subadmin-area"=>Google::Protobuf::Value.new(
                    string_value: ""
                ),
                  "zip-code"=>Google::Protobuf::Value.new(
                    string_value: ""
                ),
                  "street-address"=>Google::Protobuf::Value.new(
                    string_value: ""
                ),
                  "admin-area"=>Google::Protobuf::Value.new(
                    string_value: ""
                ),
                  "country"=>Google::Protobuf::Value.new(
                    string_value: ""
                ),
                  "business-name"=>Google::Protobuf::Value.new(
                    string_value: ""
                ),
                  "shortcut"=>Google::Protobuf::Value.new(
                    string_value: ""
                ),
                  "city"=>Google::Protobuf::Value.new(
                    string_value: "Fano"
                )
              }
            )
          ),
          "date-time"=>Google::Protobuf::Value.new(
            string_value: "2021-11-29T12:00:00+01:00"
          )
        }
      ),
      all_required_params_present: true,
      cancels_slot_filling: false,
      fulfillment_text: "",
      fulfillment_messages: [
        Google::Cloud::Dialogflow::V2::Intent::Message.new(
          platform: :PLATFORM_UNSPECIFIED,
          text: Google::Cloud::Dialogflow::V2::Intent::Message::Text.new(
            text: [""]
          )
        )
      ],
      webhook_source: "",
      output_contexts: [
        Google::Cloud::Dialogflow::V2::Context.new(
          name: "projects/italian-guy-telegram-bot/agent/sessions/a4473269cd63ac88bea1e810f72085f8/contexts/weather",
          lifespan_count: 2,
          parameters: Google::Protobuf::Struct.new(
            fields: {
              "date-time.original"=>Google::Protobuf::Value.new(
                string_value: "domani"
              ),
              "address"=>Google::Protobuf::Value.new(
                struct_value: Google::Protobuf::Struct.new(
                  fields: {
                    "island"=>Google::Protobuf::Value.new(
                      string_value: ""
                    ),
                    "subadmin-area"=>Google::Protobuf::Value.new(
                      string_value: ""
                    ),
                    "zip-code"=>Google::Protobuf::Value.new(
                      string_value: ""
                    ),
                    "street-address"=>Google::Protobuf::Value.new(
                      string_value: ""
                    ),
                    "admin-area"=>Google::Protobuf::Value.new(
                      string_value: ""
                    ),
                    "country"=>Google::Protobuf::Value.new(
                      string_value: ""
                    ),
                    "shortcut"=>Google::Protobuf::Value.new(
                      string_value: ""
                    ),
                    "business-name"=>Google::Protobuf::Value.new(
                      string_value: ""
                    ),
                    "city"=>Google::Protobuf::Value.new(
                      string_value: "Fano"
                    )
                  }
                )
              ),
              "address.original"=>Google::Protobuf::Value.new(
                string_value: "Fano"
              ),
              "date-time"=>Google::Protobuf::Value.new(
                string_value: "2021-11-29T12:00:00+01:00"
              )
            }
          )
        )
      ],
      intent: Google::Cloud::Dialogflow::V2::Intent.new(
        name: "projects/italian-guy-telegram-bot/agent/intents/f1b75ecb-a35f-4a26-88fb-5a8049b92b02",
        display_name: "weather",
        webhook_state: :WEBHOOK_STATE_UNSPECIFIED,
        priority: 0,
        is_fallback: false,
        ml_disabled: false,
        live_agent_handoff: false,
        end_interaction: false,
        input_context_names: [],
        events: [],
        training_phrases: [],
        action: "",
        output_contexts: [],
        reset_contexts: false,
        parameters: [],
        messages: [],
        default_response_platforms: [],
        root_followup_intent_name: "",
        parent_followup_intent_name: "",
        followup_intent_info: []
      ),
      intent_detection_confidence: 1.0
    )
  end
end
