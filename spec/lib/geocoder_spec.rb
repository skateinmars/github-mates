require 'spec_helper'
require 'geocoder'

describe Geocoder do
  before(:all) { VCR.insert_cassette('geocoder') }
  after(:all) { VCR.eject_cassette }

  describe ".repository" do
    it "returns a hash with the coordinates for a valid address" do
      address = "Champ de Mars, Paris, France"
      coordinates = {"lat"=>48.8556958, "lng"=>2.298464}

      Geocoder.geocode(address).should eql(coordinates)
    end

    it "returns a hash with empty coordinates for an address not found" do
      address = "Rue inexistente, Ville, France"
      coordinates = {"lat"=>nil, "lng"=>nil}

      Geocoder.geocode(address).should eql(coordinates)
    end
  end
end
