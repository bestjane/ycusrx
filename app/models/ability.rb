class Ability
  include CanCan::Ability
  
  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    if user.blank?
      cannot :manage, :all
      basic_read_only
    elsif user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :registered
      can :create, Topic
      can :update, Topic do |topic|
        topic.user_id == user.id
      end
      can :update, Topic do |topic|
        user.has_role? :moderator, topic
      end
      can :destroy, Topic do |topic|
        topic.user_id == user.id
      end
      can :destroy, Topic do |topic|
        user.has_role? :moderator, topic
      end

      can :update, Comment do |comment|
        comment.user_id == user.id
      end
      can :update, Comment do |comment|
        user.has_role? :moderator, comment
      end
      can :destroy, Comment do |comment|
        comment.user_id == user.id
      end
      can :destroy, Comment do |comment|
        user.has_role? :moderator, comment
      end
    end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
  
  protected
  def basic_read_only
    can :read, :all
  end
end
