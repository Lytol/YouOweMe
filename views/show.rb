class YouOweMe
  module Views
    class Show < Layout
      
      def collector
        @debt.collector
      end

      def debtor
        @debt.debtor
      end
      
      def item_with_quantity
        "<span class=\"quantity\">#{@debt.quantity}</span> #{@debt.item}"
      end
    end
  end
end
