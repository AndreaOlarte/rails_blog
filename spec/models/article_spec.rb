# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) { FactoryBot.build(:user) }

  it { should belong_to(:author).class_name('User') }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_most(100) }

  it 'has a valid factory' do
    expect(FactoryBot.build(:article, author: user)).to be_valid
  end
end
