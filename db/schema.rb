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

ActiveRecord::Schema[7.0].define(version: 2022_04_06_172929) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_admins_on_uid_and_provider", unique: true
  end

  create_table "economic_activities", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.string "slug"
    t.string "sankey_grouping"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emission_types", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emission_uploads", force: :cascade do |t|
    t.boolean "revised"
    t.boolean "published"
    t.string "file_name"
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sector_id", null: false
    t.index ["admin_id"], name: "index_emission_uploads_on_admin_id"
    t.index ["sector_id"], name: "index_emission_uploads_on_sector_id"
  end

  create_table "emissions", force: :cascade do |t|
    t.integer "year"
    t.decimal "value"
    t.bigint "emission_type_id", null: false
    t.bigint "territory_id", null: false
    t.bigint "sector_id", null: false
    t.bigint "economic_activity_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gas_id"
    t.integer "level_2_id"
    t.integer "level_3_id"
    t.integer "level_4_id"
    t.integer "level_5_id"
    t.integer "level_6_id"
    t.bigint "emission_upload_id", null: false
    t.index ["economic_activity_id"], name: "index_emissions_on_economic_activity_id"
    t.index ["emission_type_id"], name: "index_emissions_on_emission_type_id"
    t.index ["emission_upload_id"], name: "index_emissions_on_emission_upload_id"
    t.index ["product_id"], name: "index_emissions_on_product_id"
    t.index ["sector_id"], name: "index_emissions_on_sector_id"
    t.index ["territory_id"], name: "index_emissions_on_territory_id"
  end

  create_table "gases", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "base_color"
    t.string "level_2_description"
    t.string "level_3_description"
    t.string "level_4_description"
    t.string "level_5_description"
    t.string "level_6_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "territories", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "parent_id"
    t.integer "ibge_cod"
    t.string "acronym"
    t.string "flag_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "territory_type", null: false
  end

  add_foreign_key "emission_uploads", "admins"
  add_foreign_key "emission_uploads", "sectors"
  add_foreign_key "emissions", "economic_activities"
  add_foreign_key "emissions", "emission_types"
  add_foreign_key "emissions", "emission_uploads"
  add_foreign_key "emissions", "products"
  add_foreign_key "emissions", "sectors"
  add_foreign_key "emissions", "territories"
end
