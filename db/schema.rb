# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_21_221334) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "balances", force: :cascade do |t|
    t.bigint "balancer_1_id"
    t.bigint "balancer_2_id"
    t.float "balancer_1_debt"
    t.float "balancer_2_debt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balancer_1_id"], name: "index_balances_on_balancer_1_id"
    t.index ["balancer_2_id"], name: "index_balances_on_balancer_2_id"
  end

  create_table "balances_users", force: :cascade do |t|
    t.bigint "balance_id"
    t.bigint "user_id"
    t.index ["balance_id"], name: "index_balances_users_on_balance_id"
    t.index ["user_id"], name: "index_balances_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "balances", "users", column: "balancer_1_id"
  add_foreign_key "balances", "users", column: "balancer_2_id"
end
