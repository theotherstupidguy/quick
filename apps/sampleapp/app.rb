require 'sinatra/base'

class SampleApp < Sinatra::Base
  p "Sample App Mounted"
  get '/secret' do 
    env['warden'].authenticate!
    'Works'
    erb :"sample"
  end
end
