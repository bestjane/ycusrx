class Photo < ActiveRecord::Base
  belongs_to :user
  attr_accessible :image

  mount_uploader :image, PhotoUploader
end
