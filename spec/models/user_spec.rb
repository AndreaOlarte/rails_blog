# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { have_many(:articles).with_foreign_key('author_id') }
  it { belong_to(:comments).dependent(:destroy) }
  it { have_one(:avatar) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:password) }

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end
end
