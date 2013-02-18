class User < ActiveRecord::Base
  rolify
  before_create :set_default_role
  
  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :avatar, :avatar_cache, :remove_avatar
  
  validates :name, :presence => true, :uniqueness => true
  #validates :avatar, :presence => true, :integrity => true, :processing => true

  private
  def set_default_role
    self.add_role(:registered)
  end
end
