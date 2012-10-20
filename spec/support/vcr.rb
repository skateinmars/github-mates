require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :faraday
  c.ignore_localhost = true
  c.default_cassette_options = { :record => :new_episodes }
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    :serialize_with => :syck
  }
end
