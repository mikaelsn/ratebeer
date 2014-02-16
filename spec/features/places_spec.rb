require 'spec_helper'

describe "Places" do
	it "if one is returned by the API, it is shown at the page" do
		BeermappingApi.stub(:places_in).with("kumpula").and_return(
			[ Place.new(:name => "Oljenkorsi", id: 1) ]
		)

		visit places_path
		fill_in('city', with: 'kumpula')
		click_button "Search"

		expect(page).to have_content "Oljenkorsi"
	end

	it "if multiple is returned by the API, they are shown on the page" do
		pubit = ["Oljenkorsi", "Exactum", "Physicum"];

		BeermappingApi.stub(:places_in).with("kumpula").and_return(
			pubit.map { |pub| Place.new(name: pub, id: 1) }
		)

		visit places_path
		fill_in('city', with: 'kumpula')
		click_button "Search"

		pubit.each do |pub| 
			expect(page).to have_content pub
		end
	end

	it "if no location is returned by the API, it is shown on the page" do
		BeermappingApi.stub(:places_in).with("kumpula").and_return([])

		visit places_path
		fill_in('city', with: 'kumpula')
		click_button "Search"

		expect(page).to have_content "No locations in kumpula"
	end

end