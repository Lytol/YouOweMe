class YouOweMe
  module Views
    class Layout < Mustache

      def title
        @title || "Nag your friends when they owe you something"
      end
      
    end
  end
end