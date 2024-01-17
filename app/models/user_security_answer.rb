class UserSecurityAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :security_question

  # validations

  # end for validations

  class << self
  end
end
