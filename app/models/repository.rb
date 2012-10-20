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

  def persisted?
    false
  end

  private

  def exists_on_github
    if user.present? && repo.present?
      errors.add(:repo, "does not exist on Github") unless GithubApi.repository_exists?(user, repo)
    end
  end
end
