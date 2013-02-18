# -*- coding: utf-8 -*-
# -*- c class="pu"oding: utf-8 -*-
class Topic < ActiveRecord::Base
  include Rabel::ActiveCache
  
  resourcify
  
  belongs_to :user
  
  has_many :node_topic_mappings, :dependent => :destroy
  has_many :nodes, :through => :node_topic_mappings
  accepts_nested_attributes_for :nodes

  has_many :comments, :as => :commentable, :dependent => :destroy
  
  validates :user_id, :title, :presence => true
  validate :require_node_id_if_any_nodes
  
  attr_accessible :title, :content, :node_ids
  before_save :markdown_content
  
  def self.sticky_topics
    ts = select('updated_at').with_sticky(true).order('updated_at DESC').first.try(:updated_at)
    return Rabel::Model::EMPTY_DATASET unless ts.present?
    count = with_sticky(true).count
    Rails.cache.fetch("topics/sticky/#{ts}-#{count}") do
      with_sticky(true).order('updated_at DESC').all
    end
  end
  
  def self.with_sticky(sticky)
    where(:sticky => sticky)
  end
  
  def self.home_topics(num)
    ts = select('updated_at').order('updated_at DESC').first.try(:updated_at)
    return Rabel::Model::EMPTY_DATASET unless ts.present?
    Rails.cache.fetch("topics/recent/#{self.count}/#{num}-#{ts}") do
      order('involved_at DESC').limit(num).all
    end
  end

  def last_comment
    self.comments.order('created_at ASC').last
  end
  
  private
  def require_node_id_if_any_nodes
    if Node.any? and self.nodes.empty?
      self.errors.add(:nodes, '请至少选择一个节点')
    end
  end

  def markdown_content
    self.content_html = MarkdownTopicConverter.format(self.content) if self.content_changed?
  end
end

