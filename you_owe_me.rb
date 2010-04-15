require 'sinatra/base'
require 'mustache/sinatra'
require 'dm-core'
require 'dm-validations'
require 'digest/sha1'

class YouOweMe < Sinatra::Base
  register Mustache::Sinatra
  require 'views/layout'

  set :public, File.dirname(__FILE__) + '/public'
  set :mustache, {
    :views     => 'views',
    :templates => 'templates'
  }

  configure do
    DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://localhost/youoweme')
  end
  

  get '/' do
    mustache :index
  end
  
  post '/debts' do
    @debt = Debt.new(params[:debt])
    if @debt.save
      redirect "/debts/#{@debt.token}"
    else
      mustache :index
    end
  end
  
  get '/debts/:token' do
    @debt = Debt.first(:token => params[:token])
    mustache :show
  end
end


class Debt
  include DataMapper::Resource

  property :id,         Serial
  property :token,      String, :length => 15
  property :collector,  String, :length => 255
  property :debtor,     String, :length => 255
  property :quantity,   Integer
  property :item,       String, :length => 255
  property :notes,      String, :length => 255
  property :created_at, DateTime
  property :payed_at,   DateTime
  
  validates_present   :collector, :debtor, :quantity, :item, :notes
  validates_format    :collector, :debtor, :as => :email_address
  validates_is_number :quantity, :integer_only => true, :gt => 0
  
  before :create do
    self.token = Digest::SHA1.hexdigest([Time.now, (1..10).map{ rand.to_s }].flatten.join("--"))[0...15]
    self.created_at = Time.now
  end
end
