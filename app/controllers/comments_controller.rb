# -*- coding: utf-8 -*-
class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_commentable, :only => [:create, :edit]
  before_filter :find_comment_and_auth, :only => [:edit, :update, :destroy]
  
  # POST /comments
  # POST /comments.json
  def create
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user

    if @comment.save
      @msg = t("topics.reply_success")
    else
      @msg = @comment.errors.full_messages.join("<br />")
    end
  end
  
  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end
  
  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to custom_path(@comment.commentable), notice: '回复更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      redirect_to(custom_path(@comment.commentable), :notice => '回帖删除成功')
    else
      redirect_to(custom_path(@comment.commentable), :notice => '程序异常，回帖删除失败')
    end
  end
  
  private
  def find_commentable
    @commentable = Topic.find(params[:topic_id])
  end
  
  def find_comment_and_auth
    @comment = Comment.find(params[:id])
    authorize! :update, @comment, :message => '你没有权限管理此回复'
  end
end
