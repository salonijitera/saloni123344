class Api::UsersController < ApplicationController
  before_action :authenticate_user!

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
end
