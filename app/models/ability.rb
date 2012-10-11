class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    Rails.logger.debug "inspecting user roles #{user.assigned_roles.inspect}"
    if user.role? :admin
      can :manage, :all
    end
  
    if user.role? :god
      can :manage, :all
    end
  end
  
end