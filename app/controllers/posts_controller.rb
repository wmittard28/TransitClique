require 'pry'
require 'sinatra'
require 'sinatra/flash'

class PostsController < ApplicationController
  register Sinatra::Flash

  get '/posts' do #post index page
    if logged_in?
      @user = User.find_by_id(session[:user_id])
      @posts = Post.all
      erb :'posts/index'
    else
      redirect_if_not_logged_in
    end
  end

  get '/posts/new' do #new post
    if logged_in?
      erb :'posts/new'
    else
      redirect_if_not_logged_in
    end
  end

  post '/posts' do #create post
    if params[:post][:title] == "" || params[:post][:content] == "" || params[:post][:start_date] == "" || params[:post][:end_date] == "" || params[:post][:end_date] < params[:post][:start_date]
      flash[:message] = "Please fill in all parts! End Date must be after Start Date."
      redirect to "/posts/new"
    else
      @post = Post.new(params[:post])
      @post.user_id = current_user.id
      @post.save
    end
    redirect to "/posts/#{@post.id}"
  end

  get '/posts/:post_id' do #shows a post; also index page for comments
    if logged_in?
      @user = User.find_by_id(session[:user_id])
      @post = Post.find_by_id(params[:post_id])
      @comments = Comment.where("post_id = #{@post.id}") #all comments where post id is == the current post id
      erb :'posts/show'
    else
      redirect_if_not_logged_in
    end
  end

  get '/posts/:post_id/edit' do #edit post
    if logged_in?
      @post = Post.find_by_id(params[:post_id])
      if @post.user_id == current_user.id
       erb :'posts/edit'
      else
        redirect to "/posts" #redirect to index
      end
    else
      redirect_if_not_logged_in
    end
  end

  patch '/posts/:post_id' do #update post
    if logged_in?
      @post = Post.find_by_id(params[:post_id])
      if params[:post][:title] == "" || params[:post][:content] == "" || params[:post][:start_date] == "" || params[:post][:end_date] == "" || params[:post][:end_date] < params[:post][:start_date]
        flash[:message] = "Please fill in all parts! End Date must be after Start Date."
        redirect to "/posts/#{@post.id}/edit"
      else
        @post.update(params[:post])
        @post.save
        redirect to "/posts/#{@post.id}"
      end
    else
      redirect_if_not_logged_in
    end
  end

  delete '/posts/:post_id/delete' do #delete post
   if logged_in?
      @post = Post.find_by_id(params[:post_id])
      if @post.user_id == current_user.id
        @post.delete
        redirect to "/posts"
      else
        redirect to "/posts"
      end
    else
      redirect_if_not_logged_in
    end
  end
end
