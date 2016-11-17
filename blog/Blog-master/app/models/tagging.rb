class Tagging < ApplicationRecord

  belongs_to :tag
  belongs_to :post

  validates :tag, presence: true, uniqueness: { scope: :post_id }
  
end
