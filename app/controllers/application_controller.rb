require './config/environment'
require 'pry'
require 'sinatra'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base
  register Sinatra::Flash

  configure do
    set :public_folder, 'public'
    set :views, "app/views"
    enable :sessions  #turns session on
    set :session_secret, "password_security_key" #encryption key for session_id
  end

  get '/' do
    @user = current_user
    if logged_in?
      redirect to '/posts'
    else
      erb :welcome
    end
  end

  helpers do
    def logged_in?
      !!current_user  #!! turns value into a boolean
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def username_exists?(username)
      User.find_by(username: username) != nil #!= if not equal then true
    end

    def email_exists?(email)
      User.find_by(email: email) != nil
    end
  end
end
