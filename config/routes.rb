Rails.application.routes.draw do

  get '/' => 'pages#home'
  root to: 'pages#home'

  # uncomment the get '/signup' line (then commit, push, heroku) to add another login. hidden for now
  #
  # get '/signup' => 'users#new'
  post '/users' => 'users#create'

  # login routes
  get   '/login' => 'sessions#new'
  post  '/login' => 'sessions#create'
  get   '/logout' => 'sessions#destroy'

  # one nation reporting routes
  get '/report' => 'reports#report'
  get '/weekly' => 'reports#weekly'
  get '/monthly' => 'reports#monthly'
  get '/yearly' => 'reports#yearly'

  # megacountry reporting routes
  get '/mc' => 'megacountry#mc'
  get '/mcweekly' => 'megacountry#mcweekly'
  get '/mcmonthly' => 'megacountry#mcmonthly'
  get '/mcyearly' => 'megacountry#mcyearly'

end
