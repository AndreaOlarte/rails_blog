# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:article) { FactoryBot.create(:article, author: other_user) }
  let(:my_comment) { FactoryBot.create(:comment, article: article, user: user) }
  let(:other_comment) { FactoryBot.create(:comment, article: article, user: other_user) }
  before do
    sign_in user
  end

  describe 'GET #new' do
    it 'returns a success response and renders the new view' do
      get :new, params: { article_id: article.id }
      expect(response).to be_successful
      expect(response).to render_template('new')
    end

    it 'finds the current article to comment in' do
      get :new, params: { article_id: article.id }
      expect(assigns(:article).id).to eq(article.id)
    end

    it 'creates a new instance of Comment' do
      get :new, params: { article_id: article.id }
      expect(assigns(:comment)).to be_a_new(Comment)
    end

    it 'creates the comment to belong to the current article' do
      get :new, params: { article_id: article.id }
      expect(assigns(:comment).article.id).to eq(article.id)
    end
  end

  describe 'POST #create' do
    subject { post :create, params: {comment: params, article_id: article.id} }
    context 'with valid params' do
      let(:params) { FactoryBot.attributes_for(:comment) }

      it 'finds the current article to create the comment in' do
        subject
        expect(assigns(:article)).to eq(article)
      end

      it 'creates a new comment' do
        expect { subject }.to change(Comment, :count).by(1)
      end
    end

    context 'with invalid params' do
      let(:params) { FactoryBot.attributes_for(:comment, content: nil) }

      it 'does not create a comment' do
        expect { subject }.to change(Comment, :count).by(0)
      end

      it 'renders the new comment view' do
        expect(subject).to render_template('new')
      end
    end
  end

  describe 'GET #edit' do
    context 'when is my comment' do
      it 'returns a success response' do
        get :edit, params: {id: my_comment.id}
        expect(response).to be_successful
        expect(response).to render_template('edit')
      end

      it 'finds it' do
        get :edit, params: {id: my_comment.id}
        expect(assigns(:comment)).to eq(my_comment)
      end
    end

    context 'when is not my comment' do
      it 'does not find it' do
        expect { 
          get :edit, params: {id: other_comment.id}
        }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PUT #update' do
    context 'when is my comment' do
      subject { put :update, params: {id: my_comment.id, comment: params} }
      context 'with valid params' do
        let(:params) { FactoryBot.attributes_for(:comment) }
  
        it 'finds and updates the requested comment' do
          subject
          my_comment.reload
          expect(assigns(:comment)).to eq(my_comment)
          expect(my_comment.content).to eq(params[:content])
        end
  
        it 'returns a :found http status' do
          expect(subject).to have_http_status(:found)
        end
      end
  
      context 'with invalid params' do
        let(:params) { FactoryBot.attributes_for(:comment, content: nil) }

        it 'does not apply any changes to the requested comment' do
          subject
          my_comment.reload
          expect(my_comment.content).not_to eq(nil)
        end

        it 'renders the edit comment view' do
          expect(subject).to render_template('edit')
        end
      end
    end

    context 'when is not my comment' do
      subject { put :update, params: {id: other_comment.id, comment: params} }
      let(:params) { FactoryBot.attributes_for(:comment) }

      it 'does not find it to update' do
        expect { subject }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when is my comment' do
      it 'finds and destroys the requested comment' do
        my_second_comment = my_comment
        expect {
          delete :destroy, params: { id: my_second_comment.id }
        }.to change(Comment, :count).by(-1)
      end
    end

    context 'when is not my comment' do
      it 'does not find it to delete' do
        another_comment = other_comment
        expect { 
          delete :destroy, params: {id: another_comment.id}
        }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
