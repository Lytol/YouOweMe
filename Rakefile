require 'you_owe_me'

task :cron do  
  Debt.all(:cancelled_at => nil).each do |debt|
    Pony.mail(
      :to       => debt.debtor,
      :from     => debt.collector,
      :subject  => "You owe me #{debt.quantity} #{debt.item}",
      :body     => YouOweMe::DebtorMail.new(debt).render,
      :via      => :smtp,
      :smtp     => YouOweMe::SMTP_OPTIONS)
  end
end

namespace :db do
  
  desc "Setup the database"
  task :setup do
    Debt.auto_migrate!
  end
  
end