module ApplicationHelper
  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end
  
  def notice_message
    flash_messages = []
    
    flash.each do |type, message|
      type = :success if type == :notice
      text = content_tag(:div, link_to("x", "#", :class => "close", 'data-dismiss' => "alert") + message, :class => "alert alert-#{type}")
      flash_messages << text if message
    end
    
    flash_messages.join("\n").html_safe
  end

  def controller_stylesheet_link_tag
    case controller_name
    when "home", "users", "topics"
      stylesheet_link_tag controller_name
    when "comments"
      stylesheet_link_tag "topics"
    end
  end
  
  def controller_javascript_include_tag
    case controller_name
    when "home", "users", "topics"  
      javascript_include_tag controller_name
    when "comments"
      javascript_include_tag "topics"
    end  
  end

  def timeago(time, options = {})
    options[:class]
    options[:class] = options[:class].blank? ? "timeago" : [options[:class], "timeago"].join("")
    content_tag(:abbr, "", options.merge(:title => time.iso8601)) if time
  end
  
  def custom_path(model)
    if model.is_a? Topic
      topic_path(model.id)
    else
      model
    end
  end

  def render_page_title
    site_name = AppConfig.app_name
    title = @page_title ? "#{site_name} | #{@page_title}" : site_name rescue "SITE_NAME"
    content_tag("title", title, nil, false)
  end
end

