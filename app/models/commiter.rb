require 'github_api'
require 'geocoder'

class Commiter < ActiveRecord::Base
  has_and_belongs_to_many :repositories

  attr_accessible :login, :location, :company, :email, :blog, :avatar_url, :name

  validates_presence_of :login

  before_create :geocode_location

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

  private

  def geocode_location
    return true unless self.location.present?
    coordinates = Geocoder.geocode(self.location)
    if coordinates['lat'] && coordinates['lng']
      self.lat = coordinates['lat']
      self.lng = coordinates['lng']
    end
  end
end
