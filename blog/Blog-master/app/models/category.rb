class Category < ApplicationRecord

  has_many :posts, lambda { order(created_at: :DESC) }, dependent: :destroy
  validates :title, presence: true
  
end
