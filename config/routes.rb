require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'

  # New route added for email verification
  post '/api/users/verify-email', to: 'users#verify_email'

  namespace :api do
    # New route added for updating user profile
    put '/users/update-profile', to: 'base_controller#update_user_profile'

    namespace :users do
      # Existing route for accepting terms
      post 'accept-terms', to: 'users#accept_terms'
    end
  end

  # ... other routes ...
end
