# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid user' do
    let(:valid_user) do
      User.create(email: 'trial@email.com', password: '123456', password_confirmation: '123456')
    end

    it 'should include email' do
      expect(valid_user).to be_valid
    end

    it 'should include password' do
      expect(valid_user).to be_valid
    end
  end

  describe 'invalid user' do
    let(:invalid_user) { User.create(email: nil, password: nil, password_confirmation: nil) }
    it 'does not include email' do
      expect(invalid_user).to_not be_valid
    end

    it 'does not include password' do
      expect(invalid_user).to_not be_valid
    end
  end
end
