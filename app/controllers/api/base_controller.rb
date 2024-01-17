
# typed: ignore
module Api
  require_relative '../../services/user_service/update_profile'
  class BaseController < ActionController::API
    include ActionController::Cookies
    include Pundit::Authorization

    # =======End include module======

    rescue_from ActiveRecord::RecordNotFound, with: :base_render_record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :base_render_unprocessable_entity
    rescue_from Exceptions::AuthenticationError, with: :base_render_authentication_error
    rescue_from ActiveRecord::RecordNotUnique, with: :base_render_record_not_unique
    rescue_from Pundit::NotAuthorizedError, with: :base_render_unauthorized_error

    def error_response(resource, error)
      {
        success: false,
        full_messages: resource&.errors&.full_messages,
        errors: resource&.errors,
        error_message: error.message,
        backtrace: error.backtrace
      }
    end

    private

    def base_render_record_not_found(_exception)
      render json: { message: I18n.t('common.404') }, status: :not_found
    end

    def base_render_unprocessable_entity(exception)
      render json: { message: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

    def base_render_authentication_error(_exception)
      render json: { message: I18n.t('common.404') }, status: :not_found
    end

    def base_render_unauthorized_error(_exception)
      render json: { message: I18n.t('common.errors.unauthorized_error') }, status: :unauthorized
    end

    def base_render_record_not_unique
      render json: { message: I18n.t('common.errors.record_not_uniq_error') }, status: :forbidden
    end

    def custom_token_initialize_values(resource, client)
      token = CustomAccessToken.create(
        application_id: client.id,
        resource_owner: resource,
        scopes: resource.class.name.pluralize.downcase,
        expires_in: Doorkeeper.configuration.access_token_expires_in.seconds
      )
      @access_token = token.token
      @token_type = 'Bearer'
      @expires_in = token.expires_in
      @refresh_token = token.refresh_token
      @resource_owner = resource.class.name
      @resource_id = resource.id
      @created_at = resource.created_at
      @refresh_token_expires_in = token.refresh_expires_in
      @scope = token.scopes
    end

    def update_user_profile
      doorkeeper_authorize!
      user = current_resource_owner

      username = params[:username]
      email = params[:email]

      if username.present? && username.length > 50
        return render json: { message: "Username cannot exceed 50 characters." }, status: :bad_request
      end

      if email.present? && !User.validate_email_format(email)
        return render json: { message: "Invalid email format." }, status: :bad_request
      end

      begin
        result = UserService::UpdateProfile.new(user.id, email, nil, nil).call
        render json: { status: 200, message: result[:message] }, status: :ok
      rescue ActiveRecord::RecordNotUnique
        render json: { message: I18n.t('common.errors.record_not_uniq_error') }, status: :conflict
      rescue ArgumentError => e
        render json: { message: e.message }, status: :unprocessable_entity
      rescue StandardError => e
        render json: error_response(nil, e), status: :internal_server_error
      end
    end

    def current_resource_owner
      # Assuming the use of Doorkeeper for authentication
      return User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  end
end
