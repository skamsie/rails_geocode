Rails.application.routes.draw do
  post "authenticate", to: "authentication#authenticate"
  get "/geocode", to: "geocode#index"
end
