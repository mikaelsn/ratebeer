require 'spec_helper'

describe Beer do
  it "is created and saved with valid name and style" do
  	beer = Beer.create name: "Bisse", style: "Tumma"
  	expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
  	beer = Beer.create style: "Tumma"
  	expect(beer).not_to be_valid
  	expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
  	beer = Beer.create name: "Bisse"
  	expect(beer).not_to be_valid
  	expect(Beer.count).to eq(0)
  end
end
