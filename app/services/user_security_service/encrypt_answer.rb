module UserSecurityService
  class EncryptAnswer < BaseService
    def initialize(answer:)
      @answer = answer
    end

    def call
      BCrypt::Password.create(@answer)
    end
  end
end
