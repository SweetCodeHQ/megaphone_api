require 'rails_helper'

describe MarketKeyword do
  describe 'relationships' do
    it { should belong_to :market }
    it { should belong_to :keyword }
  end

  describe 'validations' do

  end
end
