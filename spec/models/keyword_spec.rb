require 'rails_helper'

describe Keyword do
  describe 'relationships' do
    it { should have_many :market_keywords }
    it { should have_many(:markets).through(:market_keywords) }
  end

  describe 'validations' do
    before do
      create(:keyword)
    end
    it { should validate_presence_of :word }
    it { should validate_uniqueness_of :word }
  end
end
