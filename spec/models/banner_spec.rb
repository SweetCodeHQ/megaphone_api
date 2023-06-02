require 'rails_helper'

describe Banner do
  describe 'validations' do
    it { should define_enum_for :purpose }
    it { should validate_presence_of :text }
    it { should validate_presence_of :purpose }
    it { should validate_uniqueness_of(:purpose).ignoring_case_sensitivity }

  end
end
