
class UserSecurityAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :security_question

  # validations
  validates :user_id, presence: true
  validates :security_question_id, presence: true, uniqueness: { scope: :user_id }
  validates :answer, presence: true, length: { minimum: 2, maximum: 500 }
  # end for validations

  class << self
  end
end
