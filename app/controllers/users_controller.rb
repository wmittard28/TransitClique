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
      session[:user_id] = @new_user.id
      redirect to "/posts"
    else
      flash[:message] = "Please enter in all boxes"
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
    @user = current_user
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/posts' #in posts_controller.
    elsif
      params[:username] == "" ||
      params[:password] == ""
      flash[:message] = "Please enter in all boxes"
      redirect_if_not_logged_in
    else
      flash[:message] = "The username/password you've entered does not match our records. Please try again."
      redirect_if_not_logged_in
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

end
