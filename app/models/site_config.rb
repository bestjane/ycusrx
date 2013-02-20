class SiteConfig < ActiveRecord::Base
  mount_uploader :cover, PhotoUploader
  attr_accessible :key, :title, :content, :url, :cover, :cover_cache, :remove_cover

  validates :key, :presence => true

  def self.find_by_key_first(key)
    where(:key => key.to_s).first
  end

  def self.find_by_key_last(key)
    where(:key => key.to_s).last
  end

  def self.find_by_key_all(key)
    where(:key => key.to_s).all
  end
end
