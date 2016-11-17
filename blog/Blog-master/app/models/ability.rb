class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    alias_action :edit, :update, :destroy, :to => :modify

    if user.admin?
      can :manage, :all
    else
      can :read, :all
    end

    can :modify, Post do |x|
      x.user == user
    end

    cannot :favourite, Post do |x|
      x.user == user
    end

    can :favourite, Post do |x|
      x.user != user
    end

    can :delete, Comment do |c|
      c.user == user || c.post.user == user
    end

  end
end
