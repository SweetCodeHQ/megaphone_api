require 'rails_helper'

describe User do
  describe 'relationships' do
  end

  describe 'validations' do
    before do
      create(:user)
    end
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end
end
