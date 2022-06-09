require 'rails_helper'

describe EntityMarket do
  describe 'relationships' do
    it { should belong_to :entity }
    it { should belong_to :market }
  end

  describe 'validations' do

  end
end
