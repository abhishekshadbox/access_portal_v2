class Post < ApplicationRecord
  belongs_to :organization
  belongs_to :creator, class_name: "User", optional: true
    validates :title, presence: true
  validates :content, presence: true
  validates :min_age_required, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

end
