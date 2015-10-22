require 'spec_helper'

describe Api::V1::UsersController do
  before(:each) { request.headers['Accept'] = 'application/vnd.apisonrails.v1' }

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      get :show, id: @user.id, format: :json
    end

    it 'returns the corresponding info' do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eq(@user.email)
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do

   context 'when it is valid' do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for(:user)
        post :create, { user: @user_attributes }, format: :json
      end

      it 'renders the json representation of the created user' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq @user_attributes[:email]
      end

      it { should respond_with 201 }
   end

    context 'when it is not created' do
      before(:each) do
        @invalid_user_attributes = { :password => '12345678', :password_confirmation => '12345678' }
        post :create, { user: @invalid_user_attributes }, format: :json
      end

      it 'should not be valid' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    before (:each) do
      @user = FactoryGirl.create(:user)
      patch :update, { id: @user.id, user: { email: 'newmail@example.com' }}, format: :json
    end

    context 'is a valid update' do
      it 'renders the json of the updated user' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq 'newmail@example.com'
      end

      it { should respond_with 200 }
    end

    context 'is not valid' do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { email: 'badmailexample.com' }}, format: :json
      end
      it 'renders the corresponding errors' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end
      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      delete :destroy, { id: @user.id }, format: :json
    end
    it { should respond_with 204 }
  end
end
