
module Api
  class UsersController < BaseController
    before_action :authenticate_user!, except: [:verify_email]
    before_action :doorkeeper_authorize!, only: [:set_security_questions]

    def accept_terms
      begin
        terms_and_conditions = TermsAndConditionsService::ValidateExistence.new(params[:terms_and_conditions_id]).call
        acceptance = UserTermsAcceptanceService::CreateAcceptance.new(current_user.id, terms_and_conditions.id).call
        render json: { status: 200, message: "Terms and conditions accepted." }, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      rescue ActiveRecord::RecordNotUnique => e
        render json: { error: "Terms and conditions already accepted." }, status: :unprocessable_entity
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end

    def set_security_questions
      security_question_id = params[:security_question_id]
      answer = params[:answer]

      if security_question_id.blank?
        render json: { error: "Security question not found." }, status: :not_found
        return
      end

      if answer.blank?
        render json: { error: "Answer is required." }, status: :unprocessable_entity
        return
      end

      result = UserSecurityService::SetSecurityQuestions.new(
        user_id: current_resource_owner.id,
        security_question_id: security_question_id,
        answer: answer
      ).call

      if result[:error]
        render json: { error: result[:error] }, status: :internal_server_error
      else
        render json: { status: 200, message: "Security questions set successfully." }, status: :ok
      end
    end

    def verify_email
      result = EmailVerificationService::Verify.new.call(params[:token])
      if result[:verified]
        render json: { status: 200, message: 'Email verified successfully.' }, status: :ok
      else
        case result[:error]
        when 'Invalid or expired email verification token.'
          render json: { status: 404, message: result[:error] }, status: :not_found
        else
          render json: { status: 422, message: result[:error] }, status: :unprocessable_entity
        end
      end
    rescue ActionController::ParameterMissing => e
      render json: { status: 400, message: e.message }, status: :bad_request
    rescue ActiveRecord::RecordNotFound
      render json: { status: 404, message: 'Token not found.' }, status: :not_found
    end

    def register
      # Add user registration logic here
    end

    private

    def authenticate_user!
      # Assuming there's a method to authenticate the user
      # This should set the current_user based on the authentication logic
      # If authentication fails, it should halt the action and return an unauthorized error
      raise "Not Authenticated" unless current_user
    end

    def current_user
      # Assuming there's a method to retrieve the current authenticated user
      # This is just a placeholder, actual implementation will depend on the authentication system used
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def current_resource_owner
      # Assuming there's a method to retrieve the current resource owner from doorkeeper token
      # This is just a placeholder, actual implementation will depend on the doorkeeper authentication system used
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  end
end
