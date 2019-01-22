require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { should have_and_belong_to_many(:articles) }
  it { should validate_presence_of(:category) }
  it { should validate_length_of(:category).is_at_most(25) }

  it 'has a valid factory' do
    expect(FactoryBot.build(:tag)).to be_valid
  end
end
