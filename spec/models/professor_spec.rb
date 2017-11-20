require 'rails_helper'

RSpec.describe Professor, type: :model do
  let(:professor) { build(:professor) }

  context 'attributes' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:age) }
    it { is_expected.to respond_to(:gender) }
    it { is_expected.to respond_to(:formation_area) }
  end

  context 'associations' do
    it { should belong_to(:university) }
    it { should belong_to(:campus) }
    it { should have_and_belong_to_many(:disciplines).join_table('professors_disciplines') }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:age) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:formation_area) }
    it { is_expected.to validate_numericality_of(:age) }
    it { is_expected.to validate_inclusion_of(:gender).in_array(['m', 'f']) }
  end

  context 'age' do
    it 'is a integer' do
      expect(professor.age).to be_instance_of(Integer)
    end

    it 'is greater than 18 years old' do
      expect(professor.age).to be > 18
    end
  end

  context 'formation_area' do
    it 'has one or several values splitted by commas' do
      expect(professor.formation_area).to match(/[a-zA-Z(\,)?(\s)?]/)
    end
  end

  context 'gender' do
    let(:male_professor) { build(:male_professor) }
    let(:female_professor) { build(:female_professor) }

    it 'is male or female' do
      expect(male_professor.gender.downcase).to eq('m').or eq('f')
    end

    it 'male is m case_insensitive' do
      expect(male_professor.gender.downcase).to eq('m')
    end

    it 'female is f case_insensitive' do
      expect(female_professor.gender.downcase).to eq('f')
    end

    it 'can not be written in full' do
      expect(professor.gender.length).to eq(1)
    end
  end
end
