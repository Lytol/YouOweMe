require 'sinatra/base'
require 'mustache/sinatra'
require 'dm-core'
require 'dm-validations'
require 'digest/sha1'
require 'pony'

class YouOweMe < Sinatra::Base
  register Mustache::Sinatra

  require 'views/layout'

  set :root, File.dirname(__FILE__)
  set :public, File.dirname(__FILE__) + '/public'
  set :mustache, {
    :views     => 'views',
    :templates => 'templates' }
    
  SMTP_OPTIONS =  {
    :host     => "smtp.sendgrid.net",
    :port     => "25",
    :auth     => :plain,
    :user     => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :domain   => ENV['SENDGRID_DOMAIN'] }

  require 'views/mail/collector'
  require 'views/mail/debtor'

  configure do
    DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://localhost/youoweme')
  end
  

  get '/' do
    mustache :index
  end
  
  post '/debts' do
    @debt = Debt.new(params[:debt])
    @debt.item = params[:'debt-item-custom'] if params[:'debt-item-custom'] && params[:'debt-item-custom'] != ""
    
    if @debt.save
      Pony.mail(
        :to       => @debt.collector,
        :from     => "no-reply@youoweme.mobi",
        :subject  => "[YouOweMe] #{@debt.debtor} owes you #{@debt.quantity} #{@debt.item}",
        :body     => CollectorMail.new(@debt).render,
        :via      => :smtp,
        :smtp     => SMTP_OPTIONS)
      Pony.mail(
        :to       => @debt.debtor,
        :from     => @debt.collector,
        :subject  => "You owe me #{@debt.quantity} #{@debt.item}",
        :body     => DebtorMail.new(@debt).render,
        :via      => :smtp,
        :smtp     => SMTP_OPTIONS)
      mustache :created
    else
      mustache :index
    end
  end
  
  get '/debts/:token' do
    @debt = Debt.first(:token => params[:token])
    
    if @debt.cancelled?
      mustache :cancel
    else
      mustache :show
    end
  end
  
  post '/debts/:token/cancel' do
    @debt = Debt.first(:token => params[:token])
    @debt.cancel!
    mustache :cancel
  end
end


class Debt
  include DataMapper::Resource

  property :id,           Serial
  property :token,        String, :length => 15
  property :collector,    String, :length => 255
  property :debtor,       String, :length => 255
  property :quantity,     Integer
  property :item,         String, :length => 255
  property :notes,        String, :length => 255
  property :created_at,   DateTime
  property :cancelled_at, DateTime
  
  validates_present   :debtor,:collector, :quantity, :item, :notes
  validates_format    :debtor, :collector, :as => :email_address
  validates_is_number :quantity, :integer_only => true, :gt => 0
  
  before :create do
    self.token = Digest::SHA1.hexdigest([Time.now, (1..10).map{ rand.to_s }].flatten.join("--"))[0...15]
    self.created_at = Time.now
  end
  
  def cancel!
    self.cancelled_at = Time.now
    save
  end
  
  def cancelled?
    !!cancelled_at
  end
end
