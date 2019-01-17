require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:author) { FactoryBot.create(:user) }
  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns an http :ok status" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns a success response and renders the dashboard index view' do
      get :index
      expect(response).to be_successful
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
