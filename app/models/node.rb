class Node < ActiveRecord::Base
  include Rabel::ActiveCache

  has_many :node_topic_mappings, :dependent => :destroy
  has_many :topics, :through => :node_topic_mappings

  attr_accessible :custom_html, :introduction, :key, :name
end
