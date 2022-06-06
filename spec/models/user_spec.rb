require 'rails_helper'

describe User do
  describe 'relationships' do
    it { should have_many :user_entities }
    it { should have_many(:entities).through(:user_entities) }
  end

  describe 'validations' do
    before do
      create(:user)
    end
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end
end
