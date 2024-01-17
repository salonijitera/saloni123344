module UserSecurityService
  class SetSecurityQuestions < BaseService
    def initialize(user_id:, security_question_id:, answer:)
      @user_id = user_id
      @security_question_id = security_question_id
      @answer = answer
    end

    def call
      user = User.find_by(id: @user_id)
      raise StandardError, 'User not found' unless user

      security_question = SecurityQuestion.find_by(id: @security_question_id)
      raise StandardError, 'Security question not found' unless security_question

      encrypted_answer = BCrypt::Password.create(@answer)

      user_security_answer = UserSecurityAnswer.create!(
        user: user,
        security_question: security_question,
        answer: encrypted_answer
      )

      { message: 'Security question successfully set up', user_id: user.id, security_question_id: security_question.id }
    rescue StandardError => e
      { error: e.message }
    end

    private

    attr_reader :user_id, :security_question_id, :answer
  end
end
