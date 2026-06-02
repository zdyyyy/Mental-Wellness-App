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

ActiveRecord::Schema[7.2].define(version: 2025_06_01_120000) do
  create_table "chat_messages", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "role", limit: 16, null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.index ["user_id", "created_at"], name: "index_chat_messages_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "diary_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "entry_date", null: false
    t.text "content", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "entry_date"], name: "index_diary_entries_on_user_id_and_entry_date", unique: true
    t.index ["user_id"], name: "index_diary_entries_on_user_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.string "cover_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mood_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "mood", limit: 16, null: false
    t.string "source", limit: 16, null: false
    t.datetime "recorded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "recorded_at"], name: "index_mood_entries_on_user_id_and_recorded_at"
    t.index ["user_id"], name: "index_mood_entries_on_user_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "title", null: false
    t.string "artist"
    t.integer "genre_id", null: false
    t.string "url", null: false
    t.string "cover_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_songs_on_genre_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "mood"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "chat_messages", "users"
  add_foreign_key "diary_entries", "users"
  add_foreign_key "mood_entries", "users"
  add_foreign_key "songs", "genres"
end
