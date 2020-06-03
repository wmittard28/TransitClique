require 'pry'
require 'sinatra'
require 'sinatra/flash'

class CommentsController < ApplicationController
  register Sinatra::Flash

  # NOTE: Index page for comments is on the posts show page --> '/post/:id' since only comments belonging to a post are shown.

  get '/posts/:post_id/comments/new' do #new comment
    @post = Post.find_by_id(params[:post_id])
    erb :'comments/new'
  end

  post '/posts/:post_id/comments' do  #create comment
    post_id = params[:post_id]
    if params[:comment][:content] == ""
      flash[:message] = "Boxes can't be empty"
      redirect to "/posts/#{post_id}/comments/new"
    else
      comment = params[:comment]
      comment[:post_id] = params[:post_id]
      comment[:user_id] = session[:user_id]
      @comment = Comment.create(comment)
      @comment.save
    end
    redirect to "/posts/#{post_id}/comments/#{@comment.id}"
  end

  get '/posts/:post_id/comments/:comment_id' do #show a single comment
    if logged_in?
      @post_id = params[:post_id]
      @comment = Comment.find_by_id(params[:comment_id])
      erb :'comments/show'
    else
      redirect 'login'
    end
  end

  get '/posts/:post_id/comments/:comment_id/edit' do #edit comment
    if logged_in?
      @post_id = params[:post_id]
      @comment = Comment.find_by_id(params[:comment_id])
      if @comment.user_id == current_user.id
        erb :'comments/edit'
      else
        redirect to "/posts/#{@post_id}" #redirect to comments index
      end
    else
      redirect 'login'
    end
  end

  patch '/posts/:post_id/comments/:comment_id' do #update comment
    if logged_in?
      @post_id = params[:post_id]
      @comment = Comment.find_by_id(params[:comment_id])
      if params[:comment][:content] == ""
        flash[:message] = "Boxes can't be blank"
        redirect to "/posts/#{@post_id}/comments/#{@comment.id}/edit"
      else
        @comment.update(params[:comment])
        @comment.save
        redirect to "/posts/#{@post_id}/comments/#{@comment.id}"
      end
    else
      redirect 'login'
    end
  end

  delete '/posts/:post_id/comments/:comment_id/delete' do #delete comment
    if logged_in?
      @post_id = params[:post_id]
      @comment = Comment.find_by_id(params[:comment_id])
      if @comment.user_id == current_user.id
        @comment.delete
        redirect to "/posts/#{@post_id}" #redirect to comments index
      else
        redirect to "/posts/#{@post_id}" #redirect to comments index
      end
    else
      redirect 'login'
    end
  end
end
