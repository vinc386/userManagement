require 'spec_helper'

describe SessionsController do
  render_views
  before(:each) do 
     @user = { username:'newuser',
               email:'new@user.com',
               fname:'new',
               lname:'user',
               password:'userpw',
               password_confirmation:'userpw'}
         
     @createdUser = User.create!(@user)
     
     @attr = { :session => { :email=> @createdUser.email, :password=> @createdUser.password} }
   end
  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "returns http success" do
      post :create, :session => @attr
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      get 'destroy'
      response.should be_success
    end
  end

  describe "signin failure" do
    before(:each) do
      @signin = { :email => "email@fail.com", :password => "invalid" }
    end

    it "should re-render the new page" do
      post :create, :session => @signin
      response.should render_template('new')
    end

    it "should have a flash.now message" do
      post :create, :session => @signin
      flash.now[:error].should =~ /invalid/i
    end
  end

  describe "valid signin" do

    it "should sign the user in" do 
        post :create, :session => @attr
        controller.current_user.should == @createdUser
        controller.should be_signed_in
      end
    it "should redirect to the user show page" do 
      post :create, :session => @attr 
      response.should redirect_to(users_path)
    end
  end
  
  describe "DELETE 'destroy'" do

      it "should sign a user out" do
        test_sign_in(@createdUser)
        delete :destroy
        controller.should_not be_signed_in
        response.should redirect_to(root_path)
      end
  end
end
