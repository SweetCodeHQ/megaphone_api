require 'rails_helper'

describe Market do
  describe 'relationships' do
    it { should have_many :entity_markets }
    it { should have_many(:entities).through(:entity_markets) }

    it { should have_many :market_keywords }
    it { should have_many(:keywords).through(:market_keywords) }
  end

  describe 'validations' do
    before do
      create(:market)
    end
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end
end
