require 'rails_helper'

describe User do
  describe 'relationships' do
    it { should have_many :user_entities }
    it { should have_many(:user_entities).dependent(:destroy)}

    it { should have_many(:entities).through(:user_entities) }

    it { should have_many :topics }
    it { should have_many(:topics).dependent(:destroy) }

    it { should have_many :user_keywords }
    it { should have_many(:user_keywords).dependent(:destroy) }

    it { should have_many(:keywords).through(:user_keywords) }
  end

  describe 'validations' do
    before do
      create(:user)
    end
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end
end
