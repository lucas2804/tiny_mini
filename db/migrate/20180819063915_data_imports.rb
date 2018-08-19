class DataImports < ActiveRecord::Migration[5.1]
  def change
    create_table :data_imports do |t|
      t.string :link
      t.string :file_name
      t.boolean :is_imported
      t.datetime :failed_at
      t.datetime :in_progress_at
      t.timestamps
    end
  end
end
