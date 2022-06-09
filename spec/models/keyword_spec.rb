require 'rails_helper'

describe Keyword do
  describe 'relationships' do
    # it { should have_many :user_entities }
    # it { should have_many(:entities).through(:user_entities) }
  end

  describe 'validations' do
    before do
      create(:keyword)
    end
    it { should validate_presence_of :word }
    it { should validate_uniqueness_of :word }
  end
end
