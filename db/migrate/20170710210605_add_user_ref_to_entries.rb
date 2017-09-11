class AddUserRefToEntries < ActiveRecord::Migration[5.0]
  def change
    add_reference :entries, :user, foreign_key: true
  end
end
