require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:author) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, admin: true) }
  let(:tag){ FactoryBot.create(:tag) }
  
  describe 'when any user is logged in' do
    before do
      sign_in user
    end
    
    describe 'GET #index' do
      it 'returns a success response and renders the dashboard index view' do
        get :index
        expect(response).to render_template('index')
      end
  
      it "shows all the current user's articles" do
        my_article = FactoryBot.create(:article, author: user)
        other_article = FactoryBot.create(:article, author: author)
        get :index
        expect(assigns(:articles)).to eq(user.articles.all)
      end
    end
  end

  describe 'when an admin is logged in' do
    before do
      sign_in admin
    end

    describe 'GET #index' do
      it 'shows all the tags' do
        get :index
        expect(assigns(:tags).count).to eq(Tag.count)
      end

      it 'creates a new Tag instance' do
        get :index
        expect(assigns(:tag)).to be_a_new(Tag)
      end
    end

    describe 'GET #index/tag' do
      it 'gets the tag' do
        get :index, params: {tag_id: tag}
        expect(assigns(:tag)).to eq(tag)
      end
    end
  end
end
