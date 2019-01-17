# frozen_string_literal: true

require 'rails_helper'

RSpec.feature User, type: :feature do
  let!(:user) { FactoryBot.create(:user) }
  before do
    login_as(user)
    visit '/'
  end

  describe 'a logged user' do
    scenario 'can see its profile' do
      click_link 'My Profile'
      click_link 'My Dashboard'
      expect(page).to have_content(user.name)
    end

    scenario 'can edit his information' do
      click_link 'My Profile'
      click_link 'Edit Profile'
      user_attr = FactoryBot.attributes_for(:user)
      fill_in 'Name', with: user_attr[:name]
      fill_in 'Description', with: user_attr[:description]
      fill_in 'Current password', with: user.password
      click_button 'Update'
      click_link 'My Profile'
      click_link 'My Dashboard'
      expect(page).to have_content(user_attr[:name])
      expect(page).to have_content(user_attr[:description])
    end
  end
end