# coding: utf-8
class HomeCell < BaseCell
  def about_us
    @about_us = SiteConfig.find_by_key_first("about_us")
    @about_us_shows = SiteConfig.find_by_key_all("about_us_show")
    render
  end

  def about_project
    @about_project = SiteConfig.find_by_key_first("about_project")
    @about_project_shows = SiteConfig.find_by_key_all("about_project_show")
    render
  end

  def about_train
    @about_train = SiteConfig.find_by_key_first("about_train")
    @about_train_teachers = SiteConfig.find_by_key_all("about_train_teacher")
    @about_train_works = SiteConfig.find_by_key_all("about_train_work")
    render
  end

  def about_digit
    @about_digit = SiteConfig.find_by_key_first("about_digit")
    @about_digit_pc = SiteConfig.find_by_key_all("about_digit_pc")
    @about_digit_notebook = SiteConfig.find_by_key_all("about_digit_notebook")
    @about_digit_diy = SiteConfig.find_by_key_all("about_digit_diy")
    @about_digit_parts = SiteConfig.find_by_key_all("about_digit_part")
    render
  end
end
