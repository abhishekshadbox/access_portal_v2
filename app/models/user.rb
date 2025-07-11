class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :created_organizations, class_name: "Organization", foreign_key: "creator_id"
  has_and_belongs_to_many :organizations # for enrolled orgs
  has_many :subscriptions
  has_many :subscribed_organizations, through: :subscriptions, source: :organization

  def age
    return unless date_of_birth
    now = Time.zone.today
    now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
  end
end
