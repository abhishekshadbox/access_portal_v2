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

ActiveRecord::Schema[8.0].define(version: 2025_07_11_075112) do
  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "min_age_required"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "organization_id", null: false
    t.index ["organization_id"], name: "index_organizations_users_on_organization_id"
    t.index ["user_id"], name: "index_organizations_users_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "min_age_required"
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.index ["creator_id"], name: "index_posts_on_creator_id"
    t.index ["organization_id"], name: "index_posts_on_organization_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "organization_id", null: false
    t.boolean "verified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "viewer"
    t.index ["organization_id"], name: "index_subscriptions_on_organization_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.date "date_of_birth"
    t.string "parent_email"
    t.boolean "parental_consent"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "posts", "organizations"
  add_foreign_key "posts", "users", column: "creator_id"
  add_foreign_key "subscriptions", "organizations"
  add_foreign_key "subscriptions", "users"
end
