class CreateSpots < ActiveRecord::Migration[7.0]
  def change
    create_table :spots do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :address_prefecture, null: false
      t.string :address_city, null: false
      t.string :address_detail, null: false, index: { unique: true }
      t.integer :fee, null: false, default: 0
      t.time :opening_time
      t.time :closing_time
      t.string :image

      t.timestamps
    end
  end
end
