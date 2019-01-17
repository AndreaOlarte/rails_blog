# frozen_string_literal: true

require 'rails_helper'

RSpec.feature Article, type: :feature do
  let!(:user_one) { FactoryBot.create(:user) }
  let!(:user_two) { FactoryBot.create(:user) }
  let!(:article_one) { FactoryBot.create(:article, author: user_one) }
  let!(:article_two) { FactoryBot.create(:article, author: user_two) }

  before do
    login_as(user_one)
    visit '/'
  end

  describe 'a logged user' do
    scenario 'can create articles' do
      click_link 'Write New Article'
      article = FactoryBot.attributes_for(:article)
      fill_in 'Title', with: article[:title]
      fill_in 'Content', with: article[:content]
      click_button 'Save'
      expect(page).to have_content(article[:title])
      expect(page).to have_content('Write a comment')
    end

    scenario 'can access any article to read it' do
      visit '/'
      click_link article_two.title
      expect(page).to have_content(article_two.title)
    end

    scenario 'can edit any of his own articles' do
      visit '/'
      click_link article_one.title
      click_link 'Edit'
      article = FactoryBot.attributes_for(:article)
      fill_in 'Title', with: article[:title]
      click_button 'Save'
      expect(page).to have_content(article[:title])
      expect(page).to have_content('Write a comment')
    end

    scenario "cannot edit someone else's article" do
      visit '/'
      click_link article_two.title
      expect(page).to have_no_link('Edit', href: edit_article_path(article_two))
    end

    scenario 'can delete any of his own articles' do
      visit '/'
      click_link article_one.title
      click_link 'Delete'
      expect(page).to have_content('Article was successfully destroyed.')
      expect(page).not_to have_content(article_one.title)
    end

    scenario "cannot delete someone else's article" do
      visit '/'
      click_link article_two.title
      expect(page).to have_no_link('Delete', href: article_two)
    end
  end
end