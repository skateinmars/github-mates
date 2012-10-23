require 'spec_helper'

describe Commiter do
  before(:all) { VCR.insert_cassette('commiter') }
  after(:all) { VCR.eject_cassette }

  context "a new commiter" do
    it { should validate_presence_of(:login) }

    it { should have_and_belong_to_many(:repositories) }
  end

  context "a valid commiter with a location" do
    subject { Commiter.new(:login => 'skateinmars', :location => 'Marseille, France') }

    it "should fetch its coordinates when saved" do
      subject.save!
      subject.lat.should eql(43.296482)
      subject.lng.should eql(5.36978)
    end
  end

  context "a valid commiter with an unknown location" do
    subject { Commiter.new(:login => 'skateinmars', :location => "Rue inexistente, Ville, France") }

    it "should not fetch its coordinates when saved" do
      subject.save!
      subject.lat.should be_nil
      subject.lng.should be_nil
    end
  end

  describe ".import_from_github" do
    let(:login) { 'skateinmars' }

    it "creates a commiter from github informations" do
      commiter = Commiter.import_from_github login
      commiter.login.should eql(login)
      commiter.email.should eql(GithubApi.user(login).email)
    end
  end
end
