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

ActiveRecord::Schema.define(version: 20160528205939) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "backgrounds", force: :cascade do |t|
    t.string   "name"
    t.string   "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.integer  "owner_id"
    t.integer  "balance_cents",           default: 500,   null: false
    t.string   "balance_currency",        default: "VMK", null: false
    t.integer  "line_of_credit_cents",    default: 500,   null: false
    t.string   "line_of_credit_currency", default: "VMK", null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "chapter_id"
    t.index ["chapter_id"], name: "index_bank_accounts_on_chapter_id", using: :btree
    t.index ["owner_id"], name: "index_bank_accounts_on_owner_id", using: :btree
  end

  create_table "bank_items", force: :cascade do |t|
    t.integer  "from_account_id"
    t.integer  "to_account_id"
    t.string   "item_description"
    t.integer  "item_count",       default: 1, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "bank_transactions", force: :cascade do |t|
    t.integer  "from_account_id"
    t.integer  "to_account_id"
    t.string   "memo"
    t.integer  "funds_cents",     default: 0,     null: false
    t.string   "funds_currency",  default: "VMK", null: false
    t.boolean  "posted",          default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "bonus_experiences", force: :cascade do |t|
    t.integer  "character_id"
    t.string   "reason"
    t.integer  "amount"
    t.datetime "date_awarded"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_bonus_experiences_on_character_id", using: :btree
  end

  create_table "chapters", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "default_xp", default: 0
  end

  create_table "character_backgrounds", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "background_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["background_id"], name: "index_character_backgrounds_on_background_id", using: :btree
    t.index ["character_id"], name: "index_character_backgrounds_on_character_id", using: :btree
  end

  create_table "character_events", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "event_id"
    t.boolean  "paid",                           default: false
    t.boolean  "cleaned",                        default: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "accumulated_npc_timeunits",      default: 0
    t.integer  "accumulated_npc_money_cents",    default: 0,     null: false
    t.string   "accumulated_npc_money_currency", default: "VMK", null: false
    t.boolean  "awarded",                        default: false
    t.index ["character_id"], name: "index_character_events_on_character_id", using: :btree
    t.index ["event_id"], name: "index_character_events_on_event_id", using: :btree
  end

  create_table "character_origins", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "origin_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_character_origins_on_character_id", using: :btree
    t.index ["origin_id"], name: "index_character_origins_on_origin_id", using: :btree
  end

  create_table "character_perks", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "perk_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_character_perks_on_character_id", using: :btree
    t.index ["perk_id"], name: "index_character_perks_on_perk_id", using: :btree
  end

  create_table "character_skills", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "skill_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_character_skills_on_character_id", using: :btree
    t.index ["skill_id"], name: "index_character_skills_on_skill_id", using: :btree
  end

  create_table "characters", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "race"
    t.string   "culture"
    t.integer  "costume"
    t.date     "costume_checked"
    t.boolean  "history_approval", default: false
    t.string   "history_link",     default: "https://docs.google.com/document/d/1WGDbCe0q4NvDH6FjQ5ANw97l6RIHf5Cg7_oycvHping/edit"
    t.integer  "unused_talents",   default: 0
    t.boolean  "retired",          default: false
    t.integer  "chapter_id"
    t.index ["chapter_id"], name: "index_characters_on_chapter_id", using: :btree
    t.index ["user_id"], name: "index_characters_on_user_id", using: :btree
  end

  create_table "crafting_points", force: :cascade do |t|
    t.integer "character_id"
    t.string  "type"
    t.integer "unranked",     default: 0
    t.integer "apprentice",   default: 0
    t.integer "journeyman",   default: 0
    t.integer "master",       default: 0
    t.index ["character_id"], name: "index_crafting_points_on_character_id", using: :btree
  end

  create_table "deaths", force: :cascade do |t|
    t.text     "description"
    t.string   "physical"
    t.string   "roleplay"
    t.date     "weekend"
    t.integer  "character_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "countable",    default: true
    t.index ["character_id"], name: "index_deaths_on_character_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "campaign"
    t.date     "weekend"
    t.integer  "play_exp"
    t.integer  "clean_exp"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "base_willpower"
    t.integer  "chapter_id"
    t.index ["chapter_id"], name: "index_events_on_chapter_id", using: :btree
    t.index ["weekend"], name: "index_events_on_weekend", using: :btree
  end

  create_table "npc_shifts", force: :cascade do |t|
    t.integer  "character_event_id"
    t.datetime "opening"
    t.datetime "closing"
    t.boolean  "dirty",               default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "bank_transaction_id"
    t.index ["bank_transaction_id"], name: "index_npc_shifts_on_bank_transaction_id", using: :btree
  end

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

  create_table "project_contributions", force: :cascade do |t|
    t.integer  "timeunits"
    t.integer  "character_id"
    t.integer  "project_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "note"
    t.string   "talent"
    t.index ["character_id"], name: "index_project_contributions_on_character_id", using: :btree
    t.index ["project_id"], name: "index_project_contributions_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "leader_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["leader_id"], name: "index_projects_on_leader_id", using: :btree
  end

  create_table "referrals", force: :cascade do |t|
    t.integer "referred_user_id"
    t.integer "sponsor_id"
    t.integer "event_claimed_id"
    t.index ["event_claimed_id"], name: "index_referrals_on_event_claimed_id", using: :btree
    t.index ["referred_user_id"], name: "index_referrals_on_referred_user_id", unique: true, using: :btree
    t.index ["sponsor_id"], name: "index_referrals_on_sponsor_id", using: :btree
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
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "investment_limit", default: 2
    t.index ["character_id"], name: "index_talents_on_character_id", using: :btree
  end

  create_table "temporary_effects", force: :cascade do |t|
    t.integer  "character_id"
    t.string   "attr"
    t.integer  "modifier"
    t.datetime "expiration"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_temporary_effects_on_character_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "free_cleaning_event_id"
    t.integer  "std_retirement_xp_pool", default: 0
    t.integer  "leg_retirement_xp_pool", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["free_cleaning_event_id"], name: "index_users_on_free_cleaning_event_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "bank_accounts", "characters", column: "owner_id"
  add_foreign_key "bank_items", "bank_accounts", column: "from_account_id"
  add_foreign_key "bank_items", "bank_accounts", column: "to_account_id"
  add_foreign_key "bank_transactions", "bank_accounts", column: "from_account_id"
  add_foreign_key "bank_transactions", "bank_accounts", column: "to_account_id"
  add_foreign_key "bonus_experiences", "characters"
  add_foreign_key "character_backgrounds", "backgrounds"
  add_foreign_key "character_backgrounds", "characters"
  add_foreign_key "character_events", "characters"
  add_foreign_key "character_events", "events"
  add_foreign_key "character_origins", "characters"
  add_foreign_key "character_origins", "origins"
  add_foreign_key "character_perks", "characters"
  add_foreign_key "character_perks", "perks"
  add_foreign_key "character_skills", "characters"
  add_foreign_key "character_skills", "skills"
  add_foreign_key "crafting_points", "characters"
  add_foreign_key "npc_shifts", "bank_transactions"
  add_foreign_key "npc_shifts", "character_events"
  add_foreign_key "project_contributions", "characters"
  add_foreign_key "project_contributions", "projects"
  add_foreign_key "projects", "characters", column: "leader_id"
  add_foreign_key "referrals", "events", column: "event_claimed_id"
  add_foreign_key "referrals", "users", column: "referred_user_id"
  add_foreign_key "referrals", "users", column: "sponsor_id"
  add_foreign_key "temporary_effects", "characters"
  add_foreign_key "users", "events", column: "free_cleaning_event_id"
end
