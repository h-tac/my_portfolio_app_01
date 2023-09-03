class CreateDeletionRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :deletion_requests do |t|
      t.references :spot, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
