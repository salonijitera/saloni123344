module UserService
  class UpdateProfile < BaseService
    def initialize(user_id, email, password, password_confirmation)
      @user_id = user_id
      @email = email
      @password = password
      @password_confirmation = password_confirmation
    end

    def call
      user = User.find_by(id: @user_id)
      raise ActiveRecord::RecordNotFound unless user

      if email.present?
        raise ArgumentError, 'Invalid email format' unless email.match?(URI::MailTo::EMAIL_REGEXP)
        if user.email != email
          user.email = email
          user.email_verified = false
          user.email_verification_tokens.create(token: SecureRandom.hex(10), expires_at: 24.hours.from_now)
        end
      end

      if password.present?
        raise ArgumentError, 'Password confirmation does not match' unless password == password_confirmation
        user.password_hash = User.encrypt_password(password)
      end

      user.updated_at = Time.current
      user.save!

      { message: 'Profile updated successfully', user_id: user.id, updated_fields: updated_fields(user) }
    end

    private

    attr_reader :user_id, :email, :password, :password_confirmation

    def updated_fields(user)
      fields = []
      fields << 'email' if email.present? && user.email == email
      fields << 'password' if password.present?
      fields
    end
  end
end
