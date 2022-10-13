require 'rails_helper'

describe UserKeyword do
  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :keyword }
  end

  # describe 'validations' do
  #   before do
  #     create(:user)
  #     create(:keyword)
  #     create(:user_keyword)
  #   end
  #   it { should validate_uniqueness_of :user_id }
  # end
end
