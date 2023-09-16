class AddLatitudeAndLongitudeToSpots < ActiveRecord::Migration[7.0]
  def change
    add_column :spots, :latitude, :float, null: false
    add_column :spots, :longitude, :float, null: false
    add_index :spots, [:latitude, :longitude], unique: true
  end
end
