# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:article) { FactoryBot.build(:article, author: user) }
  
  it { should belong_to(:article) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:content) }
  it { should validate_length_of(:content).is_at_most(140) }

  it 'has a valid factory' do
    expect(FactoryBot.build(:comment, article: article, user: user)).to be_valid
  end
end
