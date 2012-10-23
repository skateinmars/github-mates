require 'acceptance/acceptance_helper'

feature 'Viewing repository issues', %q{
  In order to see the issues of a repository
  As a visitor on a repository page
  I want to click the issues link
  And be able to click on a issue on the map
} do

  before do
    VCR.use_cassette('viewing_repository_issues') do
      Repository.create!(:user => 'iain', :repo => 'roundsman')
    end
  end

  scenario 'Viewing the issues', :js => true do
    visit '/repositories/iain/roundsman'
    wait_until { page.has_css?("#commiters_map div") }

    VCR.use_cassette('viewing_repository_issues') do
      click_link "Show open issues"
    end

    wait_until { page.has_content?("Issues loaded") }

    page.execute_script("google.maps.event.trigger(infowindows[infowindows.length - 1].marker, 'click');")
    page.should have_content("Reporter")
  end

end
