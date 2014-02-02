class BeerClubsController < ApplicationController

	def index
		@clubs = BeerClub.all
	end

  def show
    @club = BeerClub.find(params[:id])
  end

end
