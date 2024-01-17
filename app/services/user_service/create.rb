require 'securerandom'

module UserService
  class Create
    def self.call(username:, password:, password_confirmation:, email:)
      # Validate presence of all fields
      return { error: "Username can't be blank" } if username.blank?
      return { error: "Password can't be blank" } if password.blank?
      return { error: "Password confirmation can't be blank" } if password_confirmation.blank?
      return { error: "Email can't be blank" } if email.blank?

      # Check if password and password confirmation match
      return { error: "Password and password confirmation do not match" } unless password == password_confirmation

      # Validate email format
      return { error: "Email format is invalid" } unless email =~ URI::MailTo::EMAIL_REGEXP

      # Check if email is already registered
      return { error: "Email has already been taken" } if User.exists?(email: email)

      # Encrypt password
      encrypted_password = User.new(password: password).encrypted_password

      # Create user record
      user = User.create(
        username: username,
        password_hash: encrypted_password,
        email: email,
        email_verified: false,
        created_at: Time.current,
        updated_at: Time.current
      )

      # Generate email verification token
      token = SecureRandom.hex(10)
      EmailVerificationToken.create(
        user_id: user.id,
        token: token,
        expires_at: 24.hours.from_now
      )

      # Send confirmation email
      # Assuming Devise's mailer is set up
      user.send_confirmation_instructions

      # Return user information
      {
        user_id: user.id,
        username: user.username,
        email: user.email,
        email_verified: user.email_verified
      }
    end
  end
end
