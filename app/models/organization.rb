class Organization < ApplicationRecord
    belongs_to :creator, class_name: "User", optional: true
    validates :name, presence: true
  validates :description, presence: true
  validates :min_age_required, numericality: { only_integer: true, greater_than: 0 }
  has_many :subscriptions
  has_many :subscribed_users, through: :subscriptions, source: :user
  has_many :posts, dependent: :destroy
end
