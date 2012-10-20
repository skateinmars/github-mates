class RepositoriesController < ApplicationController
  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(params[:repository])
    if @repository.valid?
      redirect_to repository_path(:user => @repository.user, :repo => @repository.repo)
    else
      flash[:error] = "This repository does not exist"
      render :new
    end
  end

  def show
    @repository = Repository.new(:user => params[:user], :repo => params[:repo])
  end
end
