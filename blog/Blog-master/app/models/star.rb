class Star < ApplicationRecord

  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id }
  validates :post_id, presence: true
  validates :star_count, numericality: {less_than_or_equal_to: 5, greater_than_or_equal_to: 0}

end
