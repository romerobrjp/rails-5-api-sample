require 'rails_helper'

RSpec.describe Professor, type: :model do
  let(:professor1) { build(:professor) }

  context 'attributes' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:age) }
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
    it { is_expected.to validate_numericality_of(:age) }
    it { is_expected.to validate_presence_of(:formation_area) }
  end

  context 'age' do
    it 'is a integer' do
      expect(professor1.age).to be_instance_of(Integer)
    end

    it 'is greater than 18 years old' do
      expect(professor1.age).to be > 18
    end
  end

  context 'formation_area' do
    it 'has one or several values splitted by commas' do
      expect(professor1.formation_area).to match(/[a-zA-Z(\,)?(\s)?]/)
    end
  end
end
