class Ability < Spree::Ability
  def initialize(user)
    super

    user ||= Spree::User.new

    if user.admin?
      can :manage, :all
    else
      can :read, :all
    end
  end
end
