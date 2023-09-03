class CreatePumps < ActiveRecord::Migration[7.0]
  def change
    create_table :pumps do |t|
      t.string :usage, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
