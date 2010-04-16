class YouOweMe
  class DebtorMail < Mustache
    self.template_file = YouOweMe.root + "/templates/mail/debtor.mustache"

    def initialize(debt)
      @debt = debt
    end
        
    def collector
      @debt.collector
    end
    
    def notes
      @debt.notes || "something, but I can't remember what."
    end
    
    def item_with_quantity
      "#{@debt.quantity} #{@debt.item}"
    end
    
    def motiviational_quote
      quotes = [
        "Don't make me send over my muscle!",
        "You're a bum and you'll always be a bum &mdash; until you pay me, at least, then you'll be my friend again.",
        "I'm holding your dog hostage at an unnamed location. Let's not make me do anything rash...",
        "Have you ever had two broken legs? Well, you're headed in the right direction for 'em."
      ]
      quotes[rand(quotes.size)]
    end
  end
end