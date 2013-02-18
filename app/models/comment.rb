class Comment < ActiveRecord::Base
  include Rabel::ActiveCache
  
  belongs_to :user
  belongs_to :commentable, :polymorphic => true, :counter_cache => true

  validates :user_id, :commentable_id, :commentable_type, :content, :presence => true
  
  attr_accessible :content

  before_save :markdown_content
  after_create :touch_parent_model
  after_destroy :update_last_reply

  private
  def markdown_content
    self.content_html = MarkdownTopicConverter.format(self.content) if self.content_changed?
  end

  def touch_parent_model
    if commentable.has_attribute?(:last_replied_by) and commentable.has_attribute?(:last_replied_at)
      commentable.last_replied_by = self.user.name
      commentable.last_replied_at = self.created_at
      commentable.save
    end
    
    created_date = commentable.created_at.to_date
    if commentable.has_attribute?(:involved_at)
      commentable.touch(:involved_at) if created_date.months_since(6) > Time.zone.today
    else
      commentable.touch
    end
  end
  
  def update_last_reply
    if commentable.has_attribute?(:last_replied_by) and commentable.has_attribute?(:last_replied_at)
      if commentable.comments_count == 0
        commentable.last_replied_by = ''
        commentable.last_replied_at = ''
      else
        last_comment = commentable.try(:last_comment)
        if last_comment.present?
          commentable.last_replied_by = last_comment.user.name
          commentable.last_replied_at = last_comment.created_at
        end
      end
      commentable.save
    end
  end
end
