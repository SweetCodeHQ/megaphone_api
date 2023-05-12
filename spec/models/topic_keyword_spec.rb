require 'rails_helper'

describe TopicKeyword do
  describe 'relationships' do
    it { should belong_to :topic }
    it { should belong_to :keyword }
  end
end
