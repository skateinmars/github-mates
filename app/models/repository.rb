require 'github_api'

class Repository
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :user, :repo
  
  validates_presence_of :user, :repo
  validate :exists_on_github

  def initialize(params={})
    params.each do |attr, value|
      self.send("#{attr}=", value)
    end
  end

  def commiters
    GithubApi.repository_commiters_details(user, repo)
  end

  def persisted?
    false
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
