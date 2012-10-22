require 'acceptance/acceptance_helper'

feature 'Viewing repositories', %q{
  In order to see the commiters of a repository
  As a visitor
  I want to submit a valid repository
  And see the repository page
} do

  scenario 'Viewing a repository', :js => true do
    VCR.use_cassette('viewing_repositories') do
      visit '/repositories/rails/acts_as_list'

      page.should have_css('div#commiters_map div.gmnoprint')
      
      page.should_not have_content("dhh")
      page.should_not have_css('#commiters .commiter')
    end
  end

end
