class DashboardController < ApplicationController  
  before_action :set_params_for_admin

  def index
    @articles = current_user.articles.order(created_at: :DESC)
  end

  private

    def set_params_for_admin
      if current_user.admin?
        @tags = Tag.all
        @tag = params[:tag_id].present? ? Tag.find(params[:tag_id]) : Tag.new
      end
    end
end
