class CreateSpotsPumps < ActiveRecord::Migration[7.0]
  def change
    create_table :spots_pumps do |t|
      t.references :spot, null: false, foreign_key: true
      t.references :pump, null: false, foreign_key: true

      t.timestamps
    end
  end
end
