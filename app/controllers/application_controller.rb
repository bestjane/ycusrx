class ApplicationController < ActionController::Base
  protect_from_forgery

  def custom_path(model)
    if model.is_a? Topic
      topic_path(model.id)
    else
      model
    end
  end

  def drop_breadcrumb(title=nil, url=nil)
    title ||= @page_title
    url ||= url_for
    if title
      @breadcrumbs.push(%(<a href="#{url}" itemprop="url"><span itemprop="title">#{title}</span></a>).html_safe)
    end
  end

  def set_seo_meta(title='', meta_keywords='', meta_description='')
    if title.length > 0
      @page_title = "#{title}"
    end
    @meta_keywords = meta_keywords
    @meta_description = meta_description
  end

  private
  def store_location
    session[:user_return_to] = request.fullpath
  end
end
