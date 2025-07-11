# app/controllers/organizations_controller.rb
class OrganizationsController < ApplicationController
  before_action :authenticate_user!

  def index
  @my_organizations = current_user.created_organizations
  @other_organizations = Organization.where.not(creator: current_user)
  @subscriptions = current_user&.subscriptions.includes(:organization)
end

  def new
    @organization = Organization.new
  end

def create
  # @organization = Organization.new(organization_params)
  @organization = current_user.created_organizations.build(organization_params)
  if @organization.save
    redirect_to organizations_path, notice: "Organization created successfully"
  else
    Rails.logger.debug "Organization save failed: #{@organization.errors.full_messages}"
    render :new
  end
end

def analytics
  @organization = Organization.find(params[:id])
  @verified_subscribers = User.joins(:subscriptions)
                              .where(subscriptions: { organization_id: @organization.id, verified: true })

  @posts = @organization.posts.order(created_at: :desc)
end

# def subscribe
#   @organization = Organization.find(params[:id])
#   unless current_user.subscribed_organizations.include?(@organization)
#     Subscription.create(user: current_user, organization: @organization)
#     flash[:notice] = "Subscribed successfully"
#   else
#     flash[:alert] = "Already subscribed"
#   end
#   redirect_to organizations_path
# end

def subscribe
  @organization = Organization.find(params[:id])

  # Check if already subscribed
  if current_user.subscribed_organizations.include?(@organization)
    flash[:alert] = "Already subscribed"
    redirect_to organizations_path and return
  end

  # Age validation
  if current_user.date_of_birth.nil?
    flash[:alert] = "Your date of birth is not set. Please update your profile to subscribe."
    redirect_to organizations_path and return
  end

  user_age = ((Time.zone.now - current_user.date_of_birth.to_time) / 1.year.seconds).floor
  if user_age < @organization.min_age_required
    flash[:alert] = "You must be at least #{@organization.min_age_required} years old to subscribe to this organization."
    redirect_to organizations_path and return
  end

  # Create subscription
  Subscription.create(user: current_user, organization: @organization)
  flash[:notice] = "Subscribed successfully"
  redirect_to organizations_path
end


  def verify_requests
    @organization = Organization.find(params[:id])
    @pending_subscriptions = @organization.subscriptions.includes(:user).where(verified: [false, nil])
  end

  # def verify_user
  #   @organization = Organization.find(params[:id])
  #   subscription = @organization.subscriptions.find_by(user_id: params[:user_id])
  #   if subscription
  #     subscription.update(verified: true)
  #     redirect_to verify_requests_organization_path(@organization), notice: "User verified"
  #   else
  #     redirect_to verify_requests_organization_path(@organization), alert: "Subscription not found"
  #   end
  # end
def verify_user
  @organization = Organization.find(params[:id])
  user = User.find(params[:user_id])
  subscription = Subscription.find_by(user:, organization: @organization)

  if subscription && !subscription.verified?
    subscription.verified = true

    # Manually whitelist acceptable roles
    allowed_roles = ["viewer", "contributor"]
    subscription.role = allowed_roles.include?(params[:role]) ? params[:role] : "viewer"

    if subscription.save
      flash[:notice] = "User verified as #{subscription.role.humanize}"
    else
      flash[:alert] = "Failed to verify user."
    end
  else
    flash[:alert] = "Subscription not found or already verified."
  end

  redirect_to verify_requests_organization_path(@organization)
end



  def show
    @organization = Organization.find(params[:id])
    if user_age < @organization.min_age_required
      redirect_to organizations_path, alert: "You are too young to view this organization"
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :description, :min_age_required)
  end

  def user_age
    return 0 unless current_user.date_of_birth
    now = Time.zone.now.to_date
    dob = current_user.date_of_birth
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
end
