require 'spec_helper'

describe GithubApi do
  before(:all) { VCR.insert_cassette('github_api') }
  after(:all) { VCR.eject_cassette }

  describe ".repository" do
    it "returns the repository attributes" do
      repository = GithubApi.repository('rails', 'rails')
      repository.should be_a(Hash)
      repository.language.should eql("Ruby")
    end

    it "raises an error when the repository does not exist" do
      lambda {GithubApi.repository('rails', 'django')}.should raise_error
    end
  end

  describe ".repository_exists?" do
    it "returns true for an existing repository" do
      GithubApi.repository_exists?('rails', 'rails').should be_true
    end

    it "returns false when the repository does not exist" do
      GithubApi.repository_exists?('rails', 'django').should be_false
    end
  end

  describe ".repository_commiters" do
    it "returns the repository commiters list" do
      commiters = GithubApi.repository_commiters('skateinmars', 'has_url')
      commiters.should be_a(Array)
      commiters.first.login.should eql("skateinmars")
    end

    it "raises an error when the repository does not exist" do
      lambda {GithubApi.repository_commiters('rails', 'django')}.should raise_error
    end
  end

  describe ".repository_issues_users" do
    it "returns an empty list when there is no issues" do
      issues = GithubApi.repository_issues_users('skateinmars', 'has_url')
      issues.should be_empty
    end

    it "returns a list of issues and related users when there are issues" do
      issues = GithubApi.repository_issues_users('iain', 'translatable_columns')
      issues.should be_a(Array)
      issues.first[:user].should eql(Commiter.find_by_login('jensb'))
      issues.last[:issue]['title'].should eql("error with validate_translation_of")
    end

    it "filters the pull requests from the issues list and deduplicate users" do
      issues = GithubApi.repository_issues_users('iain', 'roundsman')
      issues.should be_a(Array)
      issues.length.should eql(2)
    end
  end

  describe ".user" do
    it "returns the user attributes" do
      user = GithubApi.user('rails')
      user.should be_a(Hash)
      user.login.should eql("rails")
    end

    it "raises an error when the user does not exist" do
      lambda {GithubApi.user('thisuserdoesnotexist')}.should raise_error
    end
  end
end
