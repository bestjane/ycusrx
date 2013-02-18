# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  def index
    @notices = Notice.all
  end
end
