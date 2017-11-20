require 'rails_helper'

RSpec.describe University, type: :model do
  let(:university) { build(:university) }

  context 'atrributes' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:acronym) }
    it { is_expected.to respond_to(:state) }
  end

  context 'associations' do
    it { should have_many(:professors) }
    it { should have_many(:campuses) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:acronym) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_uniqueness_of(:acronym) }
  end

  context 'acronym' do
    it 'is composed by the initial letters from the name attribute' do
      expect(university.acronym).to eq(university.name.split(' ').map { |word| word[0] }.join)
    end
  end
end