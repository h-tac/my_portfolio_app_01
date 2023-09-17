class ChangeLatitudeAndLongitudeInSpots < ActiveRecord::Migration[7.0]
  def change
    change_column :spots, :latitude, :decimal, precision: 18, scale: 14, null: false
    change_column :spots, :longitude, :decimal, precision: 18, scale: 14, null: false
  end
end
