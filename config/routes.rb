require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'

  # New route added for email verification
  post '/api/users/verify-email', to: 'users#verify_email'

  # New route added for user registration
  post '/api/users/register', to: 'api/base#register'

  namespace :api do
    namespace :users do
      # Existing route for accepting terms
      post 'accept-terms', to: 'users#accept_terms'
      # New route for setting security questions
      post '/set-security-questions', to: 'users#set_security_questions'
    end
  end

  # ... other routes ...
end
