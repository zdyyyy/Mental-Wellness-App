Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    post "auth/signup", to: "auth#signup"
    post "auth/login", to: "auth#login"
    get "auth/me", to: "auth#me"

    resource :diary, only: %i[create show], controller: "diary"

    get "music/genres", to: "music#genres"
    get "music/recommendations", to: "music#recommendations"
    get "music/genres/:genre_id/songs", to: "music#songs"
    get "music/songs/:song_id", to: "music#song"

    get "mood/trend", to: "mood#trend"
    get "mood/predict", to: "mood#predict"

    get "chat/history", to: "chat#history"
    post "chat", to: "chat#create"
  end
end
