require 'spec_helper'

describe Repository do
  before(:all) { VCR.insert_cassette('repository') }
  after(:all) { VCR.eject_cassette }

  context "a new repository" do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:repo) }
  end

  context "a repository referencing a non existing repo on Github" do
    subject { Repository.new(:user => 'rails', :repo => 'django') }

    it { should_not be_valid }
  end

  context "a repository referencing an existing repo on Github" do
    subject { Repository.new(:user => 'rails', :repo => 'acts_as_tree') }

    it { should be_valid }

    describe ".commiters" do
      it "should return an array of contributors informations" do
        subject.commiters.length.should eql(2)
      end
    end
  end
end
