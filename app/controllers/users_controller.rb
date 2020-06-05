require 'pry'
require 'sinatra'
require 'sinatra/flash'

class UsersController < ApplicationController
  register Sinatra::Flash

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    @posts = Post.where("user_id = #{@user.id}") #all posts where user id is == the current user id
    erb :'users/profile'
  end

  get '/signup' do
    if logged_in?
      redirect '/posts' #in posts_controller.
    else
      erb :'users/signup'
    end
  end

  post '/signup' do
    if params[:username] == "" ||
      params[:email] == "" ||
      params[:password] == ""
      flash[:message] = "Please enter in all boxes"
      redirect to '/signup'
    elsif
      username_exists?(params[:username]) || email_exists?(params[:email])
      flash[:message] = "Username/Email already exists"
      redirect to '/signup'
    else
      @new_user = User.create(username: params[:username],
      email: params[:email].downcase,
      password: params[:password])
      @new_user.save
      session[:user_id] = @new_user.id
      redirect '/posts' #in posts_controller.
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
    @user = User.find_by(username: params[:username])
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

  get '/logout' do
    if logged_in?
      session.clear
      redirect to '/'
    else
      redirect to '/'
    end
  end

end
