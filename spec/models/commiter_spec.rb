require 'spec_helper'

describe Commiter do
  before(:all) { VCR.insert_cassette('commiter') }
  after(:all) { VCR.eject_cassette }

  context "a new commiter" do
    it { should validate_presence_of(:login) }

    it { should have_and_belong_to_many(:repositories) }
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
