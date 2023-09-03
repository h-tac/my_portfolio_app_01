class CreateSpotsValves < ActiveRecord::Migration[7.0]
  def change
    create_table :spots_valves do |t|
      t.references :spot, null: false, foreign_key: true
      t.references :valve, null: false, foreign_key: true

      t.timestamps
    end
  end
end
