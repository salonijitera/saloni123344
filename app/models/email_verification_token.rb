
class EmailVerificationToken < ApplicationRecord
  belongs_to :user

  # validations

  # end for validations

  def generate_for_user(user)
    self.token = SecureRandom.hex(10)
    self.expires_at = 24.hours.from_now
    self.user = user
    save!
  end

  # Instance methods

  class << self
  end
end
