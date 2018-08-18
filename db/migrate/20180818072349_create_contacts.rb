class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.date :activation_date
      t.date :deactivation_date
      t.string :phone_number, limit: 20

      t.timestamps
    end
  end
end
