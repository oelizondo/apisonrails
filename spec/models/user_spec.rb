require 'spec_helper'

describe User do
  describe User do

    before { @user = FactoryGirl.build(:user) }

    subject { @user }

    context 'validations' do
      it { should respond_to :email }
      it { should respond_to :password }
      it { should respond_to :password_confirmation }

      it { should be_valid }
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of :email }
      it { should validate_confirmation_of :password }
      it { should allow_value('example@doman.com').for :email }
    end

    context 'not valid' do
      describe 'email is not present' do
        before { @user.email = '' }
        it { should_not be_valid }
      end
    end
  end
end
