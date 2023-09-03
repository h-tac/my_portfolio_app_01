class CreateValves < ActiveRecord::Migration[7.0]
  def change
    create_table :valves do |t|
      t.string :kind, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
