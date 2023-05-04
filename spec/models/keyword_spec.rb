require 'rails_helper'

describe Keyword do
  describe 'relationships' do
    it { should have_many :market_keywords }
    it { should have_many(:markets).through(:market_keywords) }
    it { should have_many :user_keywords }
    it { should have_many(:users).through(:user_keywords) }
    it { should have_many :topic_keywords }
    it { should have_many(:topics).through(:topic_keywords) } 
  end

  describe 'validations' do
    before do
      create(:keyword)
    end
    it { should validate_presence_of :word }
    it { should validate_uniqueness_of(:word).case_insensitive }
  end
end
