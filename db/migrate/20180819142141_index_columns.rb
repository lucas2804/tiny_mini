class IndexColumns < ActiveRecord::Migration[5.1]
  def change
    add_index :contacts, :phone_number
    add_index :contacts, :activation_date
    add_index :contacts, :deactivation_date
  end
end
