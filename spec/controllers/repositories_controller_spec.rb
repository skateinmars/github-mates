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
      Repository.any_instance.should_receive(:valid?).and_return(true)

      post 'create', :repository => {:user => 'user', :repo => 'name'}
    end
    
    it { should redirect_to(repository_path({:user => 'user', :repo => 'name'})) }
  end
  describe "POST 'create' failing" do
    before do
      Repository.any_instance.should_receive(:valid?).and_return(false)

      post 'create', :repository => {:user => 'user', :repo => 'name'}
    end

    it { should render_template(:new) }
    it { should set_the_flash[:error] }
  end

end
