class YouOweMe
  module Views
    class Index < Layout
      
      DEFAULT_QUANTITY = 5
      MAXIMUM_QUANTITY = 100
      
      def options_for_quantity
        options_for_quantity = []
        1.upto(MAXIMUM_QUANTITY) do |i|
          options_for_quantity << "<option name=\"#{i}\"#{ " selected=\"selected\"" if i == DEFAULT_QUANTITY }>#{i}</option>"
        end
        options_for_quantity.join("\n")
      end

      def options_for_item
        options_for_item = [
          "<option name=\"beer\">Beers</option>",
          "<option name=\"dollar\">Dollars</option>",
        ]
        options_for_item.join("\n")
      end
      
      def error_messages_for_debt
        return unless defined?(@debt) && !@debt.errors.empty?
        errors = []
        @debt.errors.each do |e|
          errors << "<li>#{e}</li>"
        end
        "<ul class=\"error-messages\">\n" + errors.join("\n") + "\n</ul>\n"
      end
      
      def random_note
        notes = [
          "sucking at bowling"
        ]
        notes[rand(notes.size)]
      end
    end
  end
end