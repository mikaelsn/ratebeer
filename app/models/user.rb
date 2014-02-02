class User < ActiveRecord::Base
	include RatingAverage

	has_secure_password

	has_many :beer_clubs, through: :memberships
	has_many :memberships, dependent: :destroy

	has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings

  validates :password, length: { minimum: 4 }, format: { with: /([A-Z]).(?=.*\d)/, message: "One uppercase and one digit required"}

	validates :username, uniqueness: true,
											 length: { minimum: 3, maximum: 15 }
end