# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { User.create(email: 'trial@email.com', password: '123456', password_confirmation: '123456') }
  let(:article) { Article.create(title: 'Title', content: 'Content', author_id: user.id) }
  describe 'valid article' do
    let(:valid_comment) do
      Comment.create(content: 'Content', user_id: user.id, article_id: article.id)
    end

    it 'should include content' do
      expect(valid_comment).to be_valid
    end
  end

  describe 'invalid comment' do
    let(:invalid_comment) do
      Comment.create(content: nil, user_id: user.id, article_id: article.id)
    end
    it 'does not include content' do
      expect(invalid_comment).to_not be_valid
    end
  end
end
