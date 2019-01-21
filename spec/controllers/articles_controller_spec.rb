# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:author) { FactoryBot.build(:user) }
  let(:my_article) { FactoryBot.create(:article, author: user) }
  let(:other_article) { FactoryBot.create(:article, author: author) }
  let(:tag) { FactoryBot.create(:tag) }
  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'is successful and renders the article index view' do
      get :index
      expect(response).to render_template('index')
    end

    it 'shows all the articles' do
      get :index
      expect(assigns(:articles).count).to eq(Article.count)
    end
  end

  describe 'GET #show' do
    it 'is successful and renders the show article view' do
      get :show, params: {id: other_article.id}
      expect(response).to render_template('show')
    end

    it 'finds the article and shows all its comments' do
      get :show, params: {id: other_article.id}
      expect(assigns(:article).id).to eq(other_article.id)
      expect(assigns(:article).comments.count).to eq(other_article.comments.count)
    end
  end

  describe 'GET #new' do
    it 'is successful and renders the new article view' do
      get :new
      expect(response).to render_template('new')
    end

    it 'creates a new instance of Article belonging to the current user' do
      get :new
      expect(assigns(:article)).to be_a_new(Article)
      expect(assigns(:article).author.id).to eq(user.id)
    end
  end

  describe 'POST #create' do
    subject { post :create, params: {article: params} }
    context 'with valid params' do
      let(:params) { FactoryBot.attributes_for(:article, tag_ids: [tag.id]) }
      it 'creates a new Article belonging to the current user' do
        expect { subject }.to change(Article, :count).by(1)
        expect(assigns(:article).author.id).to eq(user.id)
      end
    end

    context 'with invalid params' do
      let(:params) { FactoryBot.attributes_for(:article, title: nil, content: nil) }

      it 'does not create an Article' do
        expect { subject }.to change(Article, :count).by(0)
      end

      it 'renders the new article view' do
        expect(subject).to render_template('new')
      end
    end
  end

  describe 'GET #edit' do
    context 'when is my article' do
      it 'is successful and renders the edit article view' do
        get :edit, params: {id: my_article.id}
        expect(response).to render_template('edit')
      end

      it 'finds it' do
        get :edit, params: {id: my_article.id}
        expect(assigns(:article)).to eq(my_article)
      end
    end

    context 'when is not my article' do
      it 'does not findt it' do
        expect { 
          get :edit, params: {id: other_article.id}
        }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PUT #update' do
    context 'when is my article' do
      subject { put :update, params: {id: my_article.id, article: params} }
      context 'with valid params' do
        let(:params) { FactoryBot.attributes_for(:article, tag_ids: [tag.id]) }
  
        it 'finds and updates the requested article' do
          subject
          my_article.reload
          expect(assigns(:article)).to eq(my_article)
          expect(my_article.title).to eq(params[:title])
          expect(my_article.tags.first.category).to eq(tag.category)
        end
  
        it 'returns a :found http status' do
          expect(subject).to have_http_status(:found)
        end
      end
  
      context 'with invalid params' do
        let(:params) { FactoryBot.attributes_for(:article, title: nil) }
        it 'does not apply any changes to the requested article' do
          subject
          my_article.reload
          expect(my_article.title).not_to eq(nil)
        end

        it 'renders the edit article view' do
          expect(subject).to render_template('edit')
        end
      end
    end

    context 'when is not my article' do
      subject { put :update, params: {id: other_article.id, article: params} }
      let(:params) { FactoryBot.attributes_for(:article) }
      it 'does not find the article to update' do
        expect { subject }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when is my article' do
      it 'finds and destroys the requested article' do
        my_second_article = my_article
        expect {
          delete :destroy, params: { id: my_second_article.id }
        }.to change(Article, :count).by(-1)
      end
    end

    context 'when is not my article' do
      it 'does not find the article to delete' do
        another_article = other_article
        expect {
          delete :destroy, params: { id: another_article.id }
        }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
