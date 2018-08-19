class AddIndexUniqueForActivePhoneNumber < ActiveRecord::Migration[5.1]
  def change
    add_index :contacts, [:phone_number, :deactivation_date], unique: true
  end
end
