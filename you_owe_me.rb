require 'sinatra/base'
require 'mustache/sinatra'
require 'haml'

class YouOweMe < Sinatra::Base
  register Mustache::Sinatra

  set :mustache, {
    :views     => 'views/',
    :templates => 'templates/'
  }

  get '/' do
    mustache :index
  end
end
