class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.string :name
      t.string :style
      t.references :brewery, index: true

      t.timestamps
    end
  end
end
