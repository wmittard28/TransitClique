require 'pry'
require 'sinatra'
require 'sinatra/flash'

class PostsController < ApplicationController
  register Sinatra::Flash



  get '/posts' do #post index page
    if logged_in?
      @user = current_user
      @posts = Post.all
      erb :'posts/index'
    else
        flash[:message] = "Please enter in all boxes"
      redirect 'login'
    end
  end

  get '/posts/new' do #new post
    if logged_in?
      erb :'posts/new'
    else
      flash[:message] = "Please enter in all boxes"
      redirect 'login'
    end
  end

  post '/posts' do #create post
    @post = current_user.posts.new(params[:post])
    if @post.save
      redirect to "/posts/#{@post.id}"
    else
      flash[:message] = "Please enter in all boxes"
      redirect to "/posts/new"
    end
 end

  get '/posts/:post_id' do #shows a post; also index page for comments
    if logged_in?
      @user = current_user
      set_post
      @comments = @post.comments
      erb :'posts/show'
    else
      redirect 'login'
    end
  end

  get '/posts/:post_id/edit' do #edit post
    if logged_in?
       set_post
      if @post.user_id == current_user.id
       erb :'posts/edit'
      else
        redirect to "/posts" #redirect to index
      end
    else
      redirect 'login'
    end
  end


  patch '/posts/:post_id' do #update post
    set_post
    if logged_in? && @post.user_id == current_user.id
      @post.update(params[:post])
      @post.save
      redirect to "/posts/#{@post.id}"
    else
        flash[:message] = "Please enter in all boxes"
        redirect to "/posts/#{@post.id}/edit"
    end
  end

  delete '/posts/:post_id/delete' do #delete post
      set_post
      if logged_in? && @post.user_id == current_user.id
        @post.delete
        redirect to "/posts"
    else
        flash[:message] = "Please Log in"
      redirect 'login'
    end
  end

  private
  def set_post  #private method
    @post = Post.find_by_id(params[:post_id])
  end
end
