# coding: utf-8
require "digest/md5"
module UsersHelper
  # 生成用户 login 的链接，user 参数可接受 user 对象或者 字符串的 login
  def user_name_tag(user, options = {})
    name = user.name
    options['data-name'] = name
    
    link_to(name, user_path(user), options)
  end
  
  def user_avatar_width_for_size(size)
    case size
    when :normal then 48
    when :small then 16
    when :large then 64
    when :big then 120
    else size
    end
  end
  
  def user_avatar_size_name_for_2x(size)
    case size
    when :normal then :large
    when :small then :normal
    when :large then :big
    when :big then :big
    else size
    end
  end
  
  def user_avatar_tag(user, size = :normal, opts = {})
    width = user_avatar_width_for_size(size)
    
    if user.blank?
      # hash = Digest::MD5.hexdigest("") => d41d8cd98f00b204e9800998ecf8427e
      return image_tag("avatar/#{size}.png", :class => "uface")
    end
    
    if user[:avatar].blank?
      default_url = asset_path("avatar/#{size}.png")
      img = image_tag(default_url, :class => "uface", :style => "width:#{width}px;height:#{width}px;")
    else
      img = image_tag(user.avatar.url, :class => "uface", :style => "width:#{width}px;height:#{width}px;")
    end
    
    link = opts[:link] || true
    if link
      raw %(<a href="#{user_path(user.name)}">#{img}</a>)
    else
      raw img
    end
  end

  def render_user_join_time(user)
    I18n.l(user.created_at.to_date, :format => :long)
  end

  def render_user_tagline(user)
    user.tagline
  end

  def render_user_github_url(user)
    link_to(user.github_url, user.github_url, :target => "_blank", :rel => "nofollow")
  end

  def render_user_personal_website(user)
    website = user.website[/^https?:\/\//] ? user.website : "http://" + user.website
    link_to(website, website, :target => "_blank", :class => "url", :rel => "nofollow")
  end

  def render_user_level_tag(user)
    if admin?(user)
      content_tag(:span, t("common.admin_user"), :class => "label warning role")
    elsif wiki_editor?(user)
      content_tag(:span, t("common.wiki_admin"), :class => "label success role")
    else
      content_tag(:span,  t("common.limit_user"), :class => "label role")
    end
  end

end
