require 'rails_helper'

describe Market do
  describe 'relationships' do
    # it { should have_many :user_entities }
    # it { should have_many(:entities).through(:user_entities) }
  end

  describe 'validations' do
    before do
      create(:market)
    end
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end
end
