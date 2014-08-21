Rails.application.routes.draw do

  get '/' => 'pages#home'
  root to: 'pagess#home'

  # get '/signup' => 'users#new'
  post '/users' => 'users#create'

  # login routes
  get   '/login' => 'sessions#new'
  post  '/login' => 'sessions#create'
  get   '/logout' => 'sessions#destroy'

  get '/report' => 'reports#report'
  get '/weekly' => 'reports#weekly'
  get '/monthly' => 'reports#monthly'
  get '/yearly' => 'reports#yearly'

end
