module FortunaLuca
  module AI
    module Responders
      class Comparison < Base
        def call
          subjects = result.parameters.fields["subjects"].list_value&.values&.map(&:string_value)&.uniq
          return if !subjects || subjects.size < 2
          subjects.sample
        end
      end
    end
  end
end
