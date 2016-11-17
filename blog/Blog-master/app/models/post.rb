class Post < ApplicationRecord

  attr_accessor :facebook_post_this
  belongs_to :category
  belongs_to :user
  has_many :comments, lambda { order(created_at: :DESC) }, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :users_who_favored, through: :favourites, source: :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :stars, dependent: :destroy
  has_many :starers, dependent: :destroy

  validates :title, presence: true, length: { minimum: 7 },
            uniqueness: {case_sensitive: false, message: "must be unique"}
  validates :body, presence: true

  def body_snippet
    if self.body.length > 100
      return body[0...100] << "..."
    else
      return body
    end
  end

  def favourite_for(user)
    favourites.find_by(user: user)
  end

  def self.search(search)
    if search
      self.where('title ILIKE ? OR body ILIKE ?', "%#{search}%", "%#{search}%")
    else
      self.all
    end
  end

end
