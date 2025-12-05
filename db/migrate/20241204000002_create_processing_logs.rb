class CreateProcessingLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :processing_logs do |t|
      t.string :filename, null: false
      t.string :sender
      t.string :status, null: false
      t.text :extracted_data
      t.text :error_message
      t.references :customer, foreign_key: true
      t.datetime :processed_at

      t.timestamps
    end

    add_index :processing_logs, :status
    add_index :processing_logs, :sender
    add_index :processing_logs, :processed_at
  end
end
