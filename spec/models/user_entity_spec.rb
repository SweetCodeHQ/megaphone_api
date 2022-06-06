require 'rails_helper'

describe UserEntity do
  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :entity }
  end

  describe 'validations' do
    before do
      create(:user)
      create(:entity)
      create(:user_entity)
    end
    it { should validate_uniqueness_of :user_id }
  end
end
