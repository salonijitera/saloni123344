
require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'

  # New route added for email verification
  post '/api/users/verify_email', to: 'api/users#verify_email'

  post '/api/users/register', to: 'api/users#register'

  namespace :api, defaults: { format: :json } do
    namespace :users do
      # Existing route for accepting terms
      post 'accept_terms', to: 'users#accept_terms'
      # New route for setting security questions
    end
  end

  # ... other routes ...
end
