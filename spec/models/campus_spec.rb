require 'rails_helper'

RSpec.describe Campus, type: :model do
  context 'attributes' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:city) }
  end
  
  context 'associations' do
    it { should belong_to(:university) }
    it { should have_many(:professors) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
