class RepositoriesController < ApplicationController
  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.find_or_create_by_user_and_repo(params[:repository][:user], params[:repository][:repo])

    if @repository.persisted?
      redirect_to repository_path(:user => @repository.user, :repo => @repository.repo)
    else
      flash[:error] = "This repository does not exist"
      render :new
    end
  end

  def show
    @repository = Repository.find_by_user_and_repo!(params[:user], params[:repo])
  end
end
