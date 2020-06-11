require 'pry'
require 'sinatra'
require 'sinatra/flash'

class UsersController < ApplicationController
  register Sinatra::Flash

  get '/users/:slug' do #slug is object_id vs user_id
    @user = User.find_by_slug(params[:slug])
    @posts = Post.where("user_id = #{@user.id}") #all posts where user id is == the current user id
    erb :'users/profile'
  end

  get '/signup' do
    if logged_in?
      redirect '/posts'
    else
      erb :'users/signup'
    end
  end

  post '/signup' do
    @new_user = User.create(username: params[:username], email: params[:email], password: params[:password])
    if @new_user.save
      @new_user.error.full_messages
      session[:user_id] = @new_user.id
      redirect to "/posts"
    else
      redirect to '/signup'
    end
  end


  get '/login' do
    if logged_in?
      redirect '/posts'
    else
      erb :'users/login'
    end
  end

  post '/login' do
    authenticate_user
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/posts'
    else
      redirect to '/posts'
    end
  end

  get '/about' do
    erb :'users/about'
  end


  get '/logout' do
    if logged_in?
      session.clear
      redirect to '/'
    else
      redirect to '/'
    end
  end

  private
  def authenticate_user
    @user = User.find_by(username: params[:username])
  end
end
