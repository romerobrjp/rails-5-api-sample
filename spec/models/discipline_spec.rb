require 'rails_helper'

RSpec.describe Discipline, type: :model do

  context 'attributes' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:description) }
  end
  
  context 'associations' do
    it { should have_and_belong_to_many(:professors).join_table('professors_disciplines') }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
