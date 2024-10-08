Rails.application.routes.draw do
  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
  controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  namespace :api do
    namespace :v1 do
      resources :messages, only: %i[create index]
      resources :chats, only: %i[show]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
