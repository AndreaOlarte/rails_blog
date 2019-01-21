# frozen_string_literal: true

require 'rails_helper'

RSpec.feature Tag, type: :feature do
  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:user, admin: true) }
  let!(:tag) { FactoryBot.create(:tag) }
  let!(:article) { FactoryBot.create(:article, author: user, tag_ids: [tag.id]) }

  describe 'any user' do
    before do
      login_as(user)
      visit '/'
    end

    scenario 'can see the tags from any article' do
      click_link article.title
      expect(page).to have_content(tag.category)
    end
  end

  describe 'a logged non-admin user' do
    before do
      login_as(user)
      visit '/'
      click_link 'My Profile'
      click_link 'My Dashboard'
    end

    scenario 'cannot see any tag in his dashboard' do
      within('div.col-md-3') do
        expect(page).not_to have_content(tag.category)
      end
    end

    scenario 'cannot create tags' do
      expect(page).not_to have_field(:category)
    end

    scenario 'cannot edit tags' do
      expect(page).to have_no_link('Edit', href: dashboard_index_path(tag_id: tag.id))
    end

    scenario 'cannot delete tags' do
      expect(page).to have_no_link('Delete', href: admin_tag_path(tag))
    end
  end

  describe 'a logged admin user' do
    before do
      login_as(admin)
      visit '/'
      click_link 'My Profile'
      click_link 'My Dashboard'
    end

    scenario 'can see all tags in his dashboard' do
      expect(page).to have_content(tag.category)
    end

    scenario 'can create tags' do
      tag_attr = FactoryBot.attributes_for(:tag)
      fill_in 'Category', with: tag_attr[:category]
      click_button 'Save'
      expect(page).to have_content(tag_attr[:category])
    end

    scenario 'can edit any tag' do
      click_link('Edit', href: dashboard_index_path(tag_id: tag))
      tag_attr = FactoryBot.attributes_for(:tag)
      fill_in 'Category', with: tag_attr[:category]
      click_button 'Save'
      expect(page).to have_content(tag_attr[:category])
      expect(page).to have_link('Edit', href: dashboard_index_path(tag_id: tag.id))
    end

    scenario 'can delete any tag' do
      click_link('Delete', href: admin_tag_path(tag))
      expect(page).not_to have_content(tag.category)
      expect(page).to have_no_link('Delete', href: admin_tag_path(tag))
    end
  end
end