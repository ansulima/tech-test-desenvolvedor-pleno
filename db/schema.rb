#
#

ActiveRecord::Schema[7.1].define(version: 2024_12_04_000003) do
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.string "phone"
    t.string "product_code"
    t.string "subject"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email"
    t.index ["phone"], name: "index_customers_on_phone"
    t.index ["product_code"], name: "index_customers_on_product_code"
  end

  create_table "email_files", force: :cascade do |t|
    t.string "filename", null: false
    t.binary "content", null: false
    t.string "content_type"
    t.integer "file_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filename"], name: "index_email_files_on_filename"
  end

  create_table "processing_logs", force: :cascade do |t|
    t.string "filename", null: false
    t.string "sender"
    t.string "status", null: false
    t.text "extracted_data"
    t.text "error_message"
    t.bigint "customer_id"
    t.datetime "processed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_processing_logs_on_customer_id"
    t.index ["processed_at"], name: "index_processing_logs_on_processed_at"
    t.index ["sender"], name: "index_processing_logs_on_sender"
    t.index ["status"], name: "index_processing_logs_on_status"
  end

  add_foreign_key "processing_logs", "customers"
end
