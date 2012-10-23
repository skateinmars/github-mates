class RepositoriesController < ApplicationController
  before_filter :get_repository, :only => [:show, :issues]

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
  end

  def issues
    @issues = GithubApi.repository_issues_users(@repository.user, @repository.repo).map do |issue|
      {:issue => issue[:issue], :user => issue[:user].to_json}
    end

    respond_to do |format|
      format.json { render :json => @issues }
    end
  end

  private

  def get_repository
    @repository = Repository.find_by_user_and_repo!(params[:user], params[:repo])
  end
end
