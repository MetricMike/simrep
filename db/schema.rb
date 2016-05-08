  create_table "npc_shifts", force: :cascade do |t|
    t.integer  "character_event_id"
    t.datetime "opening"
    t.datetime "closing"
    t.boolean  "dirty",               default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "bank_transaction_id"
  end

  add_index "npc_shifts", ["bank_transaction_id"], name: "index_npc_shifts_on_bank_transaction_id", using: :btree

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
  end

  add_index "project_contributions", ["character_id"], name: "index_project_contributions_on_character_id", using: :btree
  add_index "project_contributions", ["project_id"], name: "index_project_contributions_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "leader_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "projects", ["leader_id"], name: "index_projects_on_leader_id", using: :btree

  create_table "referrals", force: :cascade do |t|
    t.integer "referred_user_id"
    t.integer "sponsor_id"
    t.integer "event_claimed_id"
  end

  add_index "referrals", ["event_claimed_id"], name: "index_referrals_on_event_claimed_id", using: :btree
  add_index "referrals", ["referred_user_id"], name: "index_referrals_on_referred_user_id", unique: true, using: :btree
  add_index "referrals", ["sponsor_id"], name: "index_referrals_on_sponsor_id", using: :btree

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
  end

  add_index "talents", ["character_id"], name: "index_talents_on_character_id", using: :btree

  create_table "temporary_effects", force: :cascade do |t|
    t.integer  "character_id"
    t.string   "attr"
    t.integer  "modifier"
    t.datetime "expiration"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "temporary_effects", ["character_id"], name: "index_temporary_effects_on_character_id", using: :btree

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
    t.integer  "std_retirement_xp_pool"
    t.integer  "leg_retirement_xp_pool"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["free_cleaning_event_id"], name: "index_users_on_free_cleaning_event_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

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
.datetime "created_at"
    t.datetime "updated_at"
    t.string   "race"
    t.string   "culture"
    t.integer  "costume"
    t.date     "costume_checked"
    t.boolean  "history_approval", default: false
    t.string   "history_link",     default: "https://goo.gl/DbKTlk"
    t.integer  "unused_talents",   default: 0
    t.boolean  "retired",          default: false
    t.integer  "chapter_id"
  end

  add_index "characters", ["chapter_id"], name: "index_characters_on_chapter_id", using: :btree
  add_index "characters", ["user_id"], name: "index_characters_on_user_id", using: :btree

  create_table "crafting_points", force: :cascade do |t|
    t.integer "character_id"
    t.string  "type"
    t.integer "unranked",     default: 0
    t.integer "apprentice",   default: 0
    t.integer "journeyman",   default: 0
    t.integer "master",       default: 0
  end

  add_index "crafting_points", ["character_id"], name: "index_crafting_points_on_character_id", using: :btree

  create_table "deaths", force: :cascade do |t|
    t.text     "description"
    t.string   "physical"
    t.string   "roleplay"
    t.date     "weekend"
    t.integer  "character_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "countable",    default: true
  end

  add_index "deaths", ["character_id"], name: "index_deaths_on_character_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "campaign"
    t.date     "weekend"
    t.integer  "play_exp"
    t.integer  "clean_exp"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "base_willpower"
    t.integer  "chapter_id"
  end

  add_index "events", ["chapter_id"], name: "index_events_on_chapter_id", using: :btree
  add_index "events", ["weekend"], name: "index_events_on_weekend", using: :btree

