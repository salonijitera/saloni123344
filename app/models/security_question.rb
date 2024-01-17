class SecurityQuestion < ApplicationRecord
  has_many :user_security_answers, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
