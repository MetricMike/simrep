# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150108024816) do

  create_table "backgrounds", force: :cascade do |t|
    t.string   "name"
    t.string   "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "character_backgrounds", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "background_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "character_backgrounds", ["background_id"], name: "index_character_backgrounds_on_background_id"
  add_index "character_backgrounds", ["character_id"], name: "index_character_backgrounds_on_character_id"

  create_table "character_origins", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "origin_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "character_origins", ["character_id"], name: "index_character_origins_on_character_id"
  add_index "character_origins", ["origin_id"], name: "index_character_origins_on_origin_id"

  create_table "character_perks", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "perk_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "character_perks", ["character_id"], name: "index_character_perks_on_character_id"
  add_index "character_perks", ["perk_id"], name: "index_character_perks_on_perk_id"

  create_table "character_skills", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "skill_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "character_skills", ["character_id"], name: "index_character_skills_on_character_id"
  add_index "character_skills", ["skill_id"], name: "index_character_skills_on_skill_id"

  create_table "characters", force: :cascade do |t|
    t.string   "name"
    t.integer  "experience"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "race"
    t.string   "culture"
    t.integer  "costume"
    t.date     "costume_checked"
    t.boolean  "history_approval"
    t.string   "history_link"
  end

  add_index "characters", ["user_id"], name: "index_characters_on_user_id"

  create_table "deaths", force: :cascade do |t|
    t.text     "description"
    t.string   "physical"
    t.string   "roleplay"
    t.date     "date"
    t.boolean  "perm_chance"
    t.integer  "character_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "deaths", ["character_id"], name: "index_deaths_on_character_id"

  create_table "origins", force: :cascade do |t|
    t.string   "source"
    t.string   "name"
    t.string   "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "perks", force: :cascade do |t|
    t.string   "source"
    t.string   "name"
    t.integer  "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string   "source"
    t.string   "name"
    t.integer  "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "talents", force: :cascade do |t|
    t.string   "group"
    t.string   "name"
    t.integer  "value"
    t.boolean  "spec"
    t.integer  "character_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "talents", ["character_id"], name: "index_talents_on_character_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
