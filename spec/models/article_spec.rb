# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) { User.create(email: 'trial@email.com', password: '123456', password_confirmation: '123456') }
  describe 'valid article' do
    let(:valid_article) do
      Article.create(title: 'Title', content: 'Content', author_id: user.id)
    end

    it 'should include title' do
      expect(valid_article).to be_valid
    end

    it 'should include content' do
      expect(valid_article).to be_valid
    end
  end

  describe 'invalid article' do
    let(:invalid_article) { Article.create(title: nil, content: nil) }
    it 'does not include title' do
      expect(invalid_article).to_not be_valid
    end

    it 'does not include content' do
      expect(invalid_article).to_not be_valid
    end
  end
end
