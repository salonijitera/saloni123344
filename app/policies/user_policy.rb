class UserPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def set_security_questions?
    user.present?
  end
end
