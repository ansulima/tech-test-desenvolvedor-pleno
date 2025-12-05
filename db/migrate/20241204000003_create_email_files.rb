class CreateEmailFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :email_files do |t|
      t.string :filename, null: false
      t.binary :content, null: false
      t.string :content_type
      t.integer :file_size

      t.timestamps
    end

    add_index :email_files, :filename
  end
end
