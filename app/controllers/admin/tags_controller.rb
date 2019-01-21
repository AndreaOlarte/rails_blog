module Admin
  class TagsController < ApplicationController
    before_action :check_admin_priviledges
    before_action :find_tag, only: [:update, :destroy]

    def create
      @tag = Tag.new(tag_params)
  
      if @tag.save
        redirect_back fallback_location: dashboard_index_url, notice: 'Tag was created.'
        # return
      else
        redirect_back fallback_location: dashboard_index_url
      end
    end
  
    def update
      if @tag.update(tag_params)
        redirect_to dashboard_index_url, notice: 'Tag was updated.'
      else
        redirect_back fallback_location: dashboard_index_url
      end
    end
  
    def destroy
      @tag.destroy
      redirect_back fallback_location: dashboard_index_url, notice: 'Tag was deleted.'
    end
  
    private
  
      def find_tag
        @tag = Tag.find(params[:id])
      end
  
      def tag_params
        params.require(:tag).permit(:category)
      end
  
      def check_admin_priviledges
        unless current_user.admin?
          redirect_to root_path
        end
      end
  end
end
