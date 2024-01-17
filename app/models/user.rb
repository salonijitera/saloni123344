class User < ApplicationRecord
  has_many :email_verification_tokens, dependent: :destroy
  has_many :user_security_answers, dependent: :destroy

  # validations
  validates :username, presence: { message: I18n.t('activerecord.errors.messages.blank') }
  validates :email, presence: { message: I18n.t('activerecord.errors.messages.blank') },
                    uniqueness: { message: I18n.t('activerecord.errors.messages.taken') },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.t('activerecord.errors.messages.invalid') }
  validates :password_hash, presence: { message: I18n.t('activerecord.errors.messages.blank') }
  # end for validations

  before_save :encrypt_password_instance_method

  def encrypt_password_instance_method
    self.password_hash = User.encrypt_password(password_hash) if password_hash_changed?
  end

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
