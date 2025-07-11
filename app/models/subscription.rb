class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  scope :pending, -> { where(verified: false) }
  # enum :role, %i[viewer contributor]
  
end
