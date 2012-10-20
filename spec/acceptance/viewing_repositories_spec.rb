require 'acceptance/acceptance_helper'

feature 'Viewing repositories', %q{
  In order to see the commiters of a repository
  As a visitor
  I want to submit a valid repository
  And see the repository page
} do

  scenario 'Viewing a repository' do
    VCR.use_cassette('viewing_repositories') do
      visit '/repositories/rails/acts_as_list'

      page.should have_content("dhh")
      page.should have_content("David Heinemeier Hansson")
    end
  end

end
