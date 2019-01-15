class DashboardController < ApplicationController  
  def index
    @articles = current_user.articles.order(created_at: :DESC)
  end
end
