require 'github_api'

class Repository < ActiveRecord::Base
  has_and_belongs_to_many :commiters

  attr_accessible :user, :repo

  validates_presence_of :user, :repo
  validate :exists_on_github

  after_save :add_commiters

  def to_s
    "#{user}/#{repo}"
  end

  private

  def github_repository
    @github_repository ||= (GithubApi.repository(user, repo) rescue {})
  end

  def add_commiters
    commiter_infos = GithubApi.repository_commiters(user, repo)
    commiter_infos.each do |user|
      self.commiters << Commiter.import_from_github(user.login)
    end
  end

  def exists_on_github
    if user.present? && repo.present?
      errors.add(:repo, "does not exist on Github") unless GithubApi.repository_exists?(user, repo)
    end
  end
end
