class YouOweMe
  module Views
    class Layout < Mustache

      def title
        @title || "You Owe Me"
      end
      
    end
  end
end