class AddUniqueIndexToSpotsPumps < ActiveRecord::Migration[7.0]
  def change
    add_index :spots_pumps, [:spot_id, :pump_id], unique: true
  end
end
