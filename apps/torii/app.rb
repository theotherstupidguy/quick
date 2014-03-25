#require 'bundler'
#Bundler.require

# load the Database and User model
#require './model'
require File.dirname(__FILE__) + "/models/user.rb"
#require 'rack/flash'
require 'warden'
require 'sinatra/base'

class Torii < Sinatra::Base
p "Torii app been mounted"
configure do
  set :erb, :layout => :"../../../ui/layouts/layout"
    #, :layout => :"../../ui/layouts/layout"
end 
=begin
=end

  use Rack::Session::Cookie, secret: "alanturingcanreadthisupsidedownwhileheisplayinggowith47japanesesamuraioninthedark@Aokigahara"
  #use Rack::Flash, accessorize: [:error, :success]

  use Warden::Manager do |config|
    # Tell Warden how to save our User info into a session.
    # Sessions can only take strings, not Ruby code, we'll store
    # the User's `id`
    config.serialize_into_session{|user| user._id }
    # Now tell Warden how to take what we've stored in the session
    # and get a User from that information.
    config.serialize_from_session{|_id| User.find_by(_id: _id) }

    config.scope_defaults :default,
      # "strategies" is an array of named methods with which to
      # attempt authentication. We have to define this later.
      strategies: [:password],
      # The action is a route to send the user to when
      # warden.authenticate! returns a false answer. We'll show
      # this route below.
      action: 'auth/unauthenticated'
    # When a user tries to log in and cannot, this specifies the
    # app to send the user to.
    config.failure_app = self
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['user'] && params['user']['username'] && params['user']['password']
    end

    def authenticate!
      user = User.find_by(username: params['user']['username'])
      if user.nil? 
	#|| password.nil?
        fail!("The username you entered does not exist.")
	#flash.error = ""
      elsif user.authenticate(params['user']['username'], params['user']['password'])
	#flash.success = "Successfully Logged In"
	#"Welcome "	
	p "Authenticate:" + user.username
	success!(user)
      else
        fail!("Could not log in")
      end
    end
=begin
    def current_user
      warden_handler.user
    end
    def signup!
      newuser =  User.new
      newuser.username = params['user']['username']
      newuser.password=  params['user']['password']
      newuser.save!
    end
=end
  end
  get '/' do
    erb :index 
  end

=begin
  get '/auth/login' do
    #erb :login
    erb :index
  end
=end

  post '/auth/signin' do
    env['warden'].authenticate!
    #flash.success = env['warden'].message
    if session[:return_to].nil?
      redirect '/'
    else
      redirect session[:return_to]
    end
  end


  post '/auth/signup' do
    #env['warden'].signup!

    newuser =  User.new
    newuser.username = params['user']['username']
    newuser.password=  params['user']['password']
    newuser.save!
=begin
    if session[:return_to].nil?
      redirect '/'
    else
      redirect session[:return_to]
    end
=end
      redirect '/'
  end



  get '/auth/signout' do
    env['warden'].raw_session.inspect
    env['warden'].logout
    #flash.success = 'Successfully logged out'
    redirect '/'
  end

  post '/auth/unauthenticated' do
    session[:return_to] = env['warden.options'][:attempted_path]
    puts env['warden.options'][:attempted_path]
    #flash.error = env['warden'].message || "You must log in"
    #redirect '/auth/login'
    redirect '/'
  end

  get '/protected' do
    env['warden'].authenticate!

    erb :protected 
  end

end
