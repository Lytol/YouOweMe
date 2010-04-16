class YouOweMe
  class CollectorMail < Mustache
    self.template_file = YouOweMe.root + "/templates/mail/collector.mustache"
    
    def initialize(debt)
      @debt = debt
    end

    def debtor
      @debt.debtor
    end
    
    def item_with_quantity
      "#{@debt.quantity} #{@debt.item}"
    end

    def debt_url
      "http://youoweme.heroku.com/debts/#{@debt.token}"
    end
  end
end