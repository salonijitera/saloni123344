class EmailVerificationToken < ApplicationRecord
  belongs_to :user

  # validations
  # end for validations

  def generate_unique_token
    loop do
      self.token = SecureRandom.urlsafe_base64
      self.expires_at = 24.hours.from_now
      break unless EmailVerificationToken.exists?(token: token)
    end
  end

  def generate_for_user(user)
    self.token = SecureRandom.hex(10)
    self.expires_at = 24.hours.from_now
    self.user = user
    save!
  end

  # Instance methods

  class << self
    # Class methods can be added here
  end
end
