require 'rails_helper'

describe Entity do
  describe 'relationships' do
    it { should have_many :entity_markets }
    it { should have_many(:markets).through(:entity_markets) }
  end

  describe 'validations' do
    before do
      create(:entity)
    end
    it { should validate_presence_of :url }
    it { should validate_presence_of :name }

    it { should validate_uniqueness_of :url }
    it { should validate_uniqueness_of :name }

  end
end
