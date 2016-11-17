class Comment < ApplicationRecord

  belongs_to :post
  belongs_to :user

  validates :body, presence: true, uniqueness: {case_sensitive: false, message: "must be unique"}
  
end
