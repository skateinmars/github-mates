require 'github_api'

class Commiter < ActiveRecord::Base
  has_and_belongs_to_many :repositories

  attr_accessible :login, :location, :company, :email, :blog, :avatar_url, :name

  validates_presence_of :login

  def self.import_from_github(login)
    commiter = Commiter.where(:login => login).first
    unless commiter
      user_details = GithubApi.user(login)
      commiter = self.create!(
        :login => login,
        :name => user_details.name,
        :location => user_details.location,
        :email => user_details.email,
        :company => user_details.company,
        :blog => user_details.blog,
        :avatar_url => user_details.avatar_url
      )
    end

    return commiter
  end
end
