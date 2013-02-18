# -*- coding: utf-8 -*-
class TopicsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :node]
  before_filter :find_topic_and_auth, :only => [:edit, :update, :destroy]
  
  before_filter :only => [:toggle_comments_closed, :toggle_sticky] do |c|
    authorize! :manage, Topic, :message => '你没有权限管理此主题'
  end

  before_filter :init_base_breadcrumb
  
  # GET /topics
  # GET /topics.json
  def index
    @pre_page = AppConfig.pagination_topics
    if params[:page].present?
      @current_page = params[:page].to_i
    else
      @current_page = 1
    end
    @topics = Topic.cached_pagination(@current_page, @pre_page, 'updated_at')
    drop_breadcrumb(t("topics.topic_list.hot_topic"))
    set_seo_meta("","#{AppConfig.app_name}#{t("menu.topics")}")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topics }
    end

  end
  
  # GET /topics/1
  # GET /topics/1.json
  def show
    @topic = Topic.find_cached(params[:id])
    store_location
    
    ActiveRecord::Base.connection.execute("UPDATE topics SET hit = hit + 1 WHERE topics.id = #{@topic.id}")
    
    @total_comments = @topic.comments_count
    @total_pages = (@total_comments * 1.0 / AppConfig.pagination_comments.to_i).ceil
    # @current_page = params[:p].nil? ? @total_pages : params[:p].to_i
    @current_page = params[:p].nil? ? 1 : params[:p].to_i
    @per_page = AppConfig.pagination_comments.to_i
    @comments = @topic.cached_assoc_pagination(:comments, @current_page, @per_page, 'created_at', Rabel::Model::ORDER_ASC)
    @new_comment = @topic.comments.new

    set_seo_meta("#{@topic.title} &raquo; #{t("menu.topics")}")
    drop_breadcrumb t("topics.read_topic")
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic }
    end
  end
  
  # GET /topics/new
  # GET /topics/new.json
  def new
    @topic = Topic.new
    if !params[:node].blank?
      @node = Node.find(params[:node])
      if @node.blank?
        render_404
      end
      drop_breadcrumb("#{@node.name}", node_topics_path(@node.id))
    end
    drop_breadcrumb t("topics.post_topic")
    set_seo_meta("#{t("topics.post_topic")} &raquo; #{t("menu.topics")}")
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @topic }
    end
  end
  
  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
    drop_breadcrumb t("topics.edit_topic")
    set_seo_meta("#{t("topics.edit_topic")} &raquo; #{t("menu.topics")}")
  end
  
  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(params[:topic])
    @topic.user = current_user
    
    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: '文章创建成功' }
        format.json { render json: @topic, status: :created, location: @topic }
      else
        format.html { render action: "new" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /topics/1
  # PUT /topics/1.json
  def update
    @topic = Topic.find(params[:id])
    
    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to @topic, notice: '文章更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    
    respond_to do |format|
      format.html { redirect_to topics_url }
      format.json { head :no_content }
    end
  end
  
  def toggle_comments_closed
    @topic = Topic.find(params[:topic_id])
    @topic.toggle!(:comments_closed)
    @topic.touch
    redirect_to @topic, notice: '关闭回复成功'
  end
  
  def toggle_sticky
    @topic = Topic.find(params[:topic_id])
    @topic.toggle!(:sticky)
    @topic.touch
    redirect_to @topic, notice: '置顶文章成功'
  end

  def node
    
    pre_page = AppConfig.pagination_topics
    if params[:page].present?
      current_page = params[:page].to_i
    else
      current_page = 1
    end
    
    @node = Node.find(params[:id])
    @topics = @node.cached_assoc_pagination(:topics, current_page, pre_page, 'updated_at')
    drop_breadcrumb("#{@node.name}")
    render :action => "index"
  end

  def preview
    @body = params[:body]

    respond_to do |format|
      format.json
    end
  end
    
  private
  def find_topic_and_auth
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, :message => '你没有权限管理此主题'
  end

  def init_base_breadcrumb
    drop_breadcrumb(t("menu.topics"), topics_path)
  end
end
