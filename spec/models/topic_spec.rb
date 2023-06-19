require 'rails_helper'

describe Topic do
  describe 'relationships' do
    it { should belong_to :user }
    it { should have_one(:abstract).dependent(:destroy) }
    it { should have_many(:topic_keywords) }
    it { should have_many(:keywords).through(:topic_keywords)}
  end

  describe 'validations' do
    before do
      create(:user)
      create(:topic)
    end
    it { should validate_presence_of :text }
    it { should validate_uniqueness_of :text }
    it { should define_enum_for :content_type }
  end
end
