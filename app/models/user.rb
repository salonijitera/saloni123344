
class User < ApplicationRecord
  has_many :email_verification_tokens, dependent: :destroy
  has_many :user_security_answers, dependent: :destroy

  # validations

  # end for validations

  class << self
    def validate_email_format(email)
      email =~ URI::MailTo::EMAIL_REGEXP
    end

    def encrypt_password(password)
      # Assuming the use of Devise for authentication
      Devise::Encryptor.digest(User, password)
    end
  end

  # Additional methods or validations can be added here
end
