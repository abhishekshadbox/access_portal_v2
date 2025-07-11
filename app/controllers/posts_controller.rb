class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization,except: [:all_posts]
  # before_action :check_subscription
  # before_action :check_age_access, only: [:show]

  # def index
  #   @posts = @organization.posts.where('min_age_required <= ?', user_age)
  # end
  def index
    @posts = @organization.posts
    @post = @organization.posts.new if @organization.creator == current_user
  end

  def new
    @post = @organization.posts.new
  end

  def create
    unless allowed_to_create_post?
      redirect_to organization_posts_path(@organization), alert: "You are not authorized to create a post for this organization."
      return
    end
    @post = @organization.posts.new(post_params)
    @post.creator = current_user
    if @post.save
      redirect_to organization_posts_path(@organization), notice: "Post created successfully"
    else
      render :new
    end
  end

  def show
    @post = @organization.posts.find(params[:id])
  end

  def all_posts
    user_age = current_user.age || 0

    # Fetch posts from all organizations user is subscribed to,
    # where age requirement is fulfilled

    org_ids = current_user.subscriptions.where(verified: true).pluck(:organization_id)

    @posts = Post
      .where(organization_id: org_ids)
      .where("posts.min_age_required <= ?", user_age)
      .includes(:organization)
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :min_age_required)
  end

  def user_age
    return 0 unless current_user.date_of_birth
    now = Time.zone.today
    dob = current_user.date_of_birth
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def check_subscription
    unless current_user.organizations.exists?(@organization.id)
      redirect_to organizations_path, alert: "You must subscribe to this organization to access posts."
    end
  end

  def check_age_access
    post = @organization.posts.find(params[:id])
    if user_age < post.min_age_required
      redirect_to organization_posts_path(@organization), alert: "You are too young to view this post."
    end
  end
  def allowed_to_create_post?
    return true if @organization.creator == current_user

    subscription = Subscription.find_by(user: current_user, organization: @organization)
    subscription&.verified? && subscription.role == "contributor"
  end
end
