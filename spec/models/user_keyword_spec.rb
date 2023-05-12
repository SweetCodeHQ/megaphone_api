require 'rails_helper'

describe UserKeyword do
  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :keyword }
  end
end
