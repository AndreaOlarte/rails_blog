require 'rails_helper'

RSpec.describe Admin::TagsController, type: :controller do
  let(:user){ FactoryBot.create(:user) }
  let(:admin){ FactoryBot.create(:user, admin: true) }
  let(:tag){ FactoryBot.create(:tag) }

  describe 'when a user is logged' do
    before do
      sign_in user
    end

    describe "POST #create" do
      subject { post :create, params: { tag: params } }
      let(:params) { FactoryBot.attributes_for(:tag) }
      it 'does not create any tag' do
        expect { subject }.to change(Tag, :count).by(0)
      end

      it 'redirects to the root page' do
        expect(subject).to redirect_to(root_url)
      end
    end

    describe "PUT #update" do
      subject { put :update, params: { id: tag, tag: params } }
      let(:params) { FactoryBot.attributes_for(:tag) }
      it 'does not update any tag' do
        tag_two = tag
        subject
        expect(tag_two).to eq(tag)
      end

      it 'redirects to the root page' do
        expect(subject).to redirect_to(root_url)
      end
    end

    describe "DELETE #destroy" do
      it 'does not deletes any tag' do
        tag_two = tag
        expect {
          delete :destroy, params: { id: tag_two }
        }.to change(Tag, :count).by(0)
      end

      it 'redirects to the root page' do
        tag_two = tag
        expect(
          delete :destroy, params: { id: tag_two }
        ).to redirect_to(root_url)
      end
    end
  end

  describe 'when an admin is logged' do
    before do
      sign_in admin
    end

    describe "POST #create" do
      subject { post :create, params: { tag: params } }
      context "with valid params" do
        let(:params) { FactoryBot.attributes_for(:tag) }
        it "creates a new Tag" do
          expect { subject }.to change(Tag, :count).by(1)
        end

        it "redirects to the created tag" do
          expect(subject).to redirect_to(dashboard_index_url)
        end
      end

      context "with invalid params" do
        let(:params) { FactoryBot.attributes_for(:tag, category: nil) }
        it 'does not create a Tag' do
          expect { subject }.to change(Tag, :count).by(0)
        end

        it "redirects to the dashboard" do
          subject
          expect(response).to redirect_to(dashboard_index_url)
        end
      end
    end

    describe "PUT #update" do
      subject { put :update, params: { id: tag, tag: params } }
      context "with valid params" do
        let(:params){ FactoryBot.attributes_for(:tag) }
        it "updates the requested tag" do
          subject
          tag.reload
          expect(tag.category).to eq(params[:category])
        end

        it "redirects to the dashboard" do
          subject
          tag.reload
          expect(response).to redirect_to(dashboard_index_url)
        end
      end

      context "with invalid params" do
        let(:params){ FactoryBot.attributes_for(:tag, category: nil) }
        it "does not update the tag" do
          tag_two = tag
          subject
          tag.reload
          expect(tag.category).to eq(tag_two.category)
        end

        it "redirects to the dashboard" do
          subject
          tag.reload
          expect(response).to redirect_to(dashboard_index_url)
        end
      end
    end

    describe "DELETE #destroy" do
      subject { delete :destroy, params: { id: tag } }
      it "destroys the requested tag" do
        tag_two = tag
        expect {
          delete :destroy, params: { id: tag_two }
        }.to change(Tag, :count).by(-1)
      end

      it "redirects to the dashboard" do
        tag_two = tag
        expect(
          delete :destroy, params: { id: tag_two }
        ).to redirect_to(dashboard_index_url)
      end
    end
  end
end
