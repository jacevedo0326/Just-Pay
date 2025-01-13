# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_13_164950) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "job_services", force: :cascade do |t|
    t.integer "job_id", null: false
    t.integer "service_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_services_on_job_id"
    t.index ["service_id"], name: "index_job_services_on_service_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "customer_name"
    t.date "date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "phone_number"
    t.string "notes"
    t.bigint "user_id", null: false
    t.bigint "company_owner_id"
    t.index ["company_owner_id"], name: "index_jobs_on_company_owner_id"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "company_owner_id"
    t.index ["company_owner_id"], name: "index_services_on_company_owner_id"
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "services_provideds", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user"
    t.bigint "company_owner_id"
    t.index ["company_owner_id"], name: "index_users_on_company_owner_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "job_services", "jobs"
  add_foreign_key "job_services", "services"
  add_foreign_key "jobs", "users"
  add_foreign_key "jobs", "users", column: "company_owner_id"
  add_foreign_key "services", "users"
  add_foreign_key "services", "users", column: "company_owner_id"
  add_foreign_key "users", "users", column: "company_owner_id"
end
