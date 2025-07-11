class HomeController < ApplicationController
  def index
    @featured_organizations = Organization.limit(6)
    @popular_posts = Post.includes(:organization).order(created_at: :desc).limit(6)
  end
end