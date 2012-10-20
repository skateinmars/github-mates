GithubMates::Application.routes.draw do
  root :to => 'repositories#new'

  match 'repositories/:user/:repo' => 'repositories#show', :as => :repository
  resources :repositories, :only => [:create]
end
