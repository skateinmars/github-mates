require 'spec_helper'

describe RepositoriesController do

  describe "GET 'new'" do
    before do 
      get 'new'
    end

    it { should respond_with(:success) }
    it { should render_template(:new) }
    it { should render_with_layout(:application) }
  end

  describe "POST 'create' succesful" do
    before do
      repository_mock = double()
      repository_mock.should_receive(:persisted?).and_return(true)
      repository_mock.should_receive(:user).and_return('user')
      repository_mock.should_receive(:repo).and_return('name')
      Repository.should_receive(:find_or_create_by_user_and_repo).with('user', 'name').and_return(repository_mock)

      post 'create', :repository => {:user => 'user', :repo => 'name'}
    end
    
    it { should redirect_to(repository_path({:user => 'user', :repo => 'name'})) }
  end
  describe "POST 'create' failing" do
    before do
      repository_mock = double()
      repository_mock.should_receive(:persisted?).and_return(false)
      Repository.should_receive(:find_or_create_by_user_and_repo).with('user', 'name').and_return(repository_mock)

      post 'create', :repository => {:user => 'user', :repo => 'name'}
    end

    it { should render_template(:new) }
    it { should set_the_flash[:error] }
  end

  describe "GET 'show'" do
    before do
      VCR.use_cassette('repositories_controller') do
        Repository.create!(:user => 'skateinmars', :repo => 'has_url')

        get 'show', {:user => 'skateinmars', :repo => 'has_url'}
      end
    end

    it { should respond_with(:success) }
    it { should render_template(:show) }
    it { should render_with_layout(:application) }
  end

  describe "GET 'issues'" do
    before do
      VCR.use_cassette('repositories_controller') do
        Repository.create!(:user => 'iain', :repo => 'roundsman')

        get 'issues', {:user => 'iain', :repo => 'roundsman', :format => :json}
      end
    end

    it { should respond_with(:success) }

    it "should render a json object" do
      issues = JSON.parse(response.body)
      issues.length.should eql(2)
    end
  end
end
