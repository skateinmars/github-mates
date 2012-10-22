require 'acceptance/acceptance_helper'

feature 'Viewing repositories', %q{
  In order to see the commiters of a repository
  As a visitor
  I want to visit a repository page
  And see the commiters on a map
} do

  before do
    VCR.use_cassette('viewing_repositories') do
      Repository.create!(:user => 'rails', :repo => 'acts_as_list')
    end
  end

  scenario 'Viewing a repository', :js => true do
    visit '/repositories/rails/acts_as_list'
    wait_until { page.has_css?("#commiters_map div") }

    page.should have_css('div#commiters_map div.gmnoprint')
    
    page.should_not have_content("dhh")
    page.should_not have_css('#commiters .commiter')

    page.execute_script("google.maps.event.trigger(infowindows[3].marker, 'click');")
    page.should have_content("David Heinemeier Hansson")
  end

end
