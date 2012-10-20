module HelperMethods
  def should_be_on(path)
    page.current_path.should == path
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance