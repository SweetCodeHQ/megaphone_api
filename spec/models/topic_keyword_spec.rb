require 'rails_helper'

describe TopicKeyword do
  describe 'relationships' do
    it { should belong_to :topic }
    it { should belong_to :keyword }
  end

  describe 'validations' do
    before do
      create(:user)
      create(:topic)
      create(:keyword)
      create(:topic_keyword)
    end
    it { should validate_uniqueness_of :keyword }
  end
end
