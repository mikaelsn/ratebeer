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


	def favorite_beer
		return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
			return nil if ratings.empty?
			ratings.joins(:beer)
			.group(:style)
			.order(score: :desc)
			.limit(1).first.beer.style
		end

		def favorite_brewery
			return nil if ratings.empty?
			ratings.joins(:beer)
			.group(:brewery_id)
			.order(score: :desc)
			.limit(1).first.beer.brewery
		end
end