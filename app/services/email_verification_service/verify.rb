module EmailVerificationService
  class Verify < BaseService
    def call(token)
      email_verification_token = EmailVerificationToken.find_by(token: token, 'expires_at > ?', Time.current)

      if email_verification_token
        user = email_verification_token.user
        if user.update(email_verified: true)
          email_verification_token.destroy
          { verified: true }
        else
          { verified: false, error: 'Unable to update user email verification status.' }
        end
      else
        { verified: false, error: 'Invalid or expired email verification token.' }
      end
    rescue StandardError => e
      Rails.logger.error "Email verification failed: #{e.message}"
      { verified: false, error: e.message }
    end
  end
end

# Note: BaseService is assumed to be present in the application and inherited by this service.
