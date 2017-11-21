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
    let(:university_with_prepositions) { build(:university, :prepositions_in_name) }

    it 'accepts name without prepositions' do
      expect(university.acronym.length).to be >= (university.name.split(' ').select { |word| word[0] == word[0].upcase }.length)
    end

    it 'accepts name with prepositions' do
      expect(university_with_prepositions.acronym.length).to be >= (university_with_prepositions.name.split(' ').select { |word| word[0] == word[0].upcase }.length)
    end
  end
end