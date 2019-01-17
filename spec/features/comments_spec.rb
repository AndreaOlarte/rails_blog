# frozen_string_literal: true

require 'rails_helper'

RSpec.feature Comment, type: :feature do
  let!(:user_one) { FactoryBot.create(:user) }
  let!(:user_two) { FactoryBot.create(:user) }
  let!(:article) { FactoryBot.create(:article, author: user_one) }
  let!(:comment_one) { FactoryBot.create(:comment, article: article, user: user_one)}
  let!(:comment_two) { FactoryBot.create(:comment, article: article, user: user_two)}
  before do
    login_as(user_one)
    visit '/'
  end

  describe 'a logged user' do
    scenario 'can see any comment on any article' do
      visit '/'
      click_link article.title
      expect(page).to have_content(comment_two.content)
    end

    scenario 'can create comments in any article' do
      visit '/'
      click_link article.title
      click_link 'Write a comment'
      comment = FactoryBot.attributes_for(:comment)
      fill_in 'Content', with: comment[:content]
      click_button 'Save'
      expect(page).to have_content(article.title)
      expect(page).to have_content(comment[:content])
    end

    scenario 'can edit any of his own comments in any article' do
      visit '/'
      click_link article.title
      click_link('', href: edit_comment_path(comment_one))
      comment = FactoryBot.attributes_for(:comment)
      fill_in 'Content', with: comment[:content]
      click_button 'Save'
      expect(page).to have_content(article.title)
      expect(page).to have_content(comment[:content])
    end

    scenario "cannot edit someone else's comment in any article" do
      visit '/'
      click_link article.title
      expect(page).to have_no_link('Edit', href: edit_comment_path(comment_two))
    end

    scenario 'can delete any of his own comments in any article' do
      visit '/'
      click_link article.title
      click_link('', href: comment_path(comment_one))
      expect(page).to have_content('Comment was removed.')
      expect(page).not_to have_content('This is my comment')
    end

    scenario "cannot delete someone else's comment" do
      visit '/'
      click_link article.title
      expect(page).to have_no_link('Delete', href: comment_two)
    end
  end
end