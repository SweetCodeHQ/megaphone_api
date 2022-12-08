require 'rails_helper'

describe Topic do
  describe 'relationships' do
    it { should belong_to :user }
    it { should have_one :abstract }
  end

  describe 'validations' do
    before do
      create(:user)
      create(:topic)
    end
    it { should validate_presence_of :text }
    it { should validate_uniqueness_of :text }
  end
end
