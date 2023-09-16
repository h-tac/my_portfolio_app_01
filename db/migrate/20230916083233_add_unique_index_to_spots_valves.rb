class AddUniqueIndexToSpotsValves < ActiveRecord::Migration[7.0]
  def change
    add_index :spots_valves, [:spot_id, :valve_id], unique: true
  end
end
