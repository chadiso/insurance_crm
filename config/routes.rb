Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  resources :imports, only: %i[new create show index]

  root 'imports#new'
end
