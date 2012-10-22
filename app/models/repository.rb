require 'github_api'

class Repository < ActiveRecord::Base
  attr_accessible :user, :repo

  validates_presence_of :user, :repo
  validate :exists_on_github

  def commiters
    GithubApi.repository_commiters_details(user, repo)
  end

  def to_s
    "#{user}/#{repo}"
  end

  private

  def github_repository
    @github_repository ||= (GithubApi.repository(user, repo) rescue {})
  end

  def exists_on_github
    if user.present? && repo.present?
      errors.add(:repo, "does not exist on Github") unless GithubApi.repository_exists?(user, repo)
    end
  end
end
