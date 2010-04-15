require 'you_owe_me'

namespace :db do
  
  desc "Setup the database"
  task :setup do
    Debt.auto_migrate!
  end
  
end