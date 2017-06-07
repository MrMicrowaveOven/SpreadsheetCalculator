Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # get 'spreadsheets/new'
  # resources :spreadsheets
  root 'spreadsheets#new'
  get "/spreadsheets" => "spreadsheets#index"
  post "/spreadsheets" => "spreadsheets#create"
  delete "/spreadsheets" => "spreadsheets#destroy"
end
