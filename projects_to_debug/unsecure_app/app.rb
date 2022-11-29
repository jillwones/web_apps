require 'sinatra/base'
require "sinatra/reloader"

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  post '/hello' do
    @name = params[:name]
    if @name =~ /^[a-zA-Z\s]+$/
      return erb(:hello)
    else 
      return redirect('/')
    end
  end
end
