class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :phone_number, limit: 20
      t.date :activation_date
      t.date :deactivation_date
    end
  end
end
