require './config/environment'
require 'pry'
require 'sinatra'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base
  register Sinatra::Flash

  configure do
    set :public_folder, 'public'
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security_key"
  end

  get '/' do
    @user = User.find_by_id(session[:user_id])
    if logged_in?
      redirect to '/posts'
    else
      erb :welcome
    end
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def username_exists?(username)
      User.find_by(username: username) != nil
    end

    def email_exists?(email)
      User.find_by(email: email) != nil
    end
  end
end
