class SetNullOnUserDeleteInSpots < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :spots, :users

    add_foreign_key :spots, :users, on_delete: :nullify
  end
end
