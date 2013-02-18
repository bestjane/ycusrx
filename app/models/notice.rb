class Notice < ActiveRecord::Base
  resourcify
  attr_accessible :text, :title
end
