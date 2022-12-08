require 'rails_helper'

describe Abstract do
  describe 'relationships' do
    it { should belong_to :topic }
  end

  describe 'validations' do
    it { should validate_presence_of :text }
  end
end
