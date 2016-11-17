class User < ApplicationRecord
  
  attr_accessor :current_password
  has_many :comments, dependent: :nullify
  has_many :posts, dependent: :nullify
  has_many :favourites, dependent: :destroy
  has_many :favourite_posts, through: :favourites, source: :post
  has_many :stars, dependent: :destroy
  has_many :starred_posts, through: :stars, source: :post

  has_secure_password

  before_validation :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
                    uniqueness: {case_sensitive: false },
                    format: VALID_EMAIL_REGEX,
                    unless: :from_oauth?

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      full_name = (auth.info.name).split
      user.first_name = full_name[0]
      user.last_name = full_name[1]
      user.email = auth.info.email
      user.password = SecureRandom.hex(32)
      user.provider = auth.provider
      user.uid = auth.uid
      user.oauth_token = auth.credentials.token
      user.oauth_secret = auth.credentials.secret
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.oauth_raw_data = auth
      user.save!
    end
  end

  def full_name
   "#{first_name} #{last_name}".strip.squeeze(' ').titleize
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
  end

  def from_oauth?
    provider.present? && uid.present?
  end

  def signed_in_with_facebook?
    uid.present? && provider == 'facebook'
  end

  private

  def downcase_email
    self.email.downcase! if email.present?
  end

end
