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

ActiveRecord::Schema[8.0].define(version: 2025_03_17_013724) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "invitations", force: :cascade do |t|
    t.string "invitation_token", null: false
    t.datetime "accepted_at"
    t.datetime "expired_at"
    t.bigint "sender_id", null: false
    t.bigint "recipient_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invitation_token"], name: "index_invitations_on_invitation_token", unique: true
    t.index ["recipient_id"], name: "index_invitations_on_recipient_id"
    t.index ["sender_id"], name: "index_invitations_on_sender_id"
    t.index ["team_id", "sender_id", "recipient_id"], name: "index_invitations_on_team_id_and_sender_id_and_recipient_id", unique: true
    t.index ["team_id"], name: "index_invitations_on_team_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_memberships_on_team_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.bigint "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_teams_on_creator_id"
    t.index ["name", "deleted_at"], name: "index_teams_on_name_and_deleted_at", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.string "description", null: false
    t.integer "status", default: 0, null: false
    t.decimal "credit", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "debit", precision: 10, scale: 2, default: "0.0", null: false
    t.string "type", null: false
    t.string "creator_type", null: false
    t.bigint "creator_id", null: false
    t.bigint "source_id", null: false
    t.bigint "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_type", "creator_id"], name: "index_transactions_on_creator"
    t.index ["source_id"], name: "index_transactions_on_source_id"
    t.index ["target_id"], name: "index_transactions_on_target_id"
    t.index ["type", "creator_id", "creator_type"], name: "index_transactions_on_type_and_creator_id_and_creator_type", unique: true
    t.index ["type", "source_id", "status"], name: "index_transactions_on_type_and_source_id_and_status", unique: true
    t.index ["type", "source_id", "target_id", "status"], name: "idx_on_type_source_id_target_id_status_cb7a85c15c", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "deleted_at"], name: "index_users_on_email_and_deleted_at", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.string "number", null: false
    t.string "name", null: false
    t.boolean "primary", default: false, null: false
    t.decimal "balance", precision: 10, scale: 2, default: "0.0", null: false
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "deleted_at"], name: "index_wallets_on_name_and_deleted_at", unique: true
    t.index ["number"], name: "index_wallets_on_number"
    t.index ["owner_id", "owner_type", "deleted_at"], name: "index_wallets_on_owner_id_and_owner_type_and_deleted_at", unique: true
    t.index ["owner_type", "owner_id"], name: "index_wallets_on_owner"
  end

  add_foreign_key "invitations", "teams"
  add_foreign_key "invitations", "users", column: "recipient_id"
  add_foreign_key "invitations", "users", column: "sender_id"
  add_foreign_key "memberships", "teams"
  add_foreign_key "memberships", "users"
  add_foreign_key "teams", "users", column: "creator_id"
  add_foreign_key "transactions", "wallets", column: "source_id"
  add_foreign_key "transactions", "wallets", column: "target_id"
end
