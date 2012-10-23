GithubMates::Application.routes.draw do
  root :to => 'repositories#new'

  match 'repositories/:user/:repo' => 'repositories#show', :as => :repository, :constraints => { :repo => /[^\/]*/ }
  match 'repositories/:user/:repo/issues' => 'repositories#issues', :as => :repository_issues, :constraints => { :repo => /[^\/]*/ }
  resources :repositories, :only => [:create]
end
