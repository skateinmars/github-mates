require 'acceptance/acceptance_helper'

feature 'Creating repositories', %q{
  In order to visualize a repository
  As a visitor
  I want to submit a repository
} do

  scenario 'Submitting a repository of a non existent user' do
    VCR.use_cassette('creating_repositories') do
      visit homepage

      fill_in "User", :with => 'nonexistent'
      fill_in "Repo", :with => 'nonexistent'
      click_button "Submit"
      
      should_be_on '/repositories'
      page.should have_content("repository does not exist")
    end
  end

  scenario 'Submitting an existing repository' do
    VCR.use_cassette('creating_repositories') do
      visit homepage

      fill_in "User", :with => 'skateinmars'
      fill_in "Repo", :with => 'has_url'
      click_button "Submit"
      
      should_be_on '/repositories/skateinmars/has_url'
    end
  end

end
