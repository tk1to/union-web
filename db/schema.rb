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

ActiveRecord::Schema.define(version: 20170311174321) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blogs", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "circle_id"
    t.integer  "author_id"
    t.string   "header_1"
    t.string   "header_2"
    t.string   "header_3"
    t.text     "content_1"
    t.text     "content_2"
    t.text     "content_3"
    t.string   "picture_1"
    t.string   "picture_2"
    t.string   "picture_3"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "circle_categories", force: :cascade do |t|
    t.integer  "circle_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "priority"
  end

  add_index "circle_categories", ["category_id"], name: "index_circle_categories_on_category_id", using: :btree
  add_index "circle_categories", ["circle_id"], name: "index_circle_categories_on_circle_id", using: :btree

  create_table "circles", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "name"
    t.text     "description"
    t.string   "picture"
    t.string   "header_picture"
    t.string   "join_colleges"
    t.string   "people_scale"
    t.string   "activity_place"
    t.string   "activity_frequency"
    t.string   "annual_fee"
    t.string   "party_frequency"
  end

  create_table "contacts", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "content"
    t.integer  "send_user_id"
    t.integer  "receive_circle_id"
  end

  create_table "entries", force: :cascade do |t|
    t.integer  "circle_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "entries", ["circle_id", "user_id"], name: "index_entries_on_circle_id_and_user_id", unique: true, using: :btree
  add_index "entries", ["circle_id"], name: "index_entries_on_circle_id", using: :btree
  add_index "entries", ["user_id"], name: "index_entries_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
    t.text     "content"
    t.integer  "circle_id"
    t.string   "picture"
    t.string   "schedule"
    t.string   "fee"
    t.string   "capacity"
    t.string   "place"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "circle_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "favorites", ["circle_id", "user_id"], name: "index_favorites_on_circle_id_and_user_id", unique: true, using: :btree
  add_index "favorites", ["circle_id"], name: "index_favorites_on_circle_id", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "foot_prints", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "footed_user_id"
    t.integer  "footer_user_id"
    t.boolean  "checked",        default: false
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "member_id"
    t.integer  "circle_id"
    t.integer  "status",     default: 3
  end

  add_index "memberships", ["circle_id"], name: "index_memberships_on_circle_id", using: :btree
  add_index "memberships", ["member_id", "circle_id"], name: "index_memberships_on_member_id_and_circle_id", unique: true, using: :btree
  add_index "memberships", ["member_id"], name: "index_memberships_on_member_id", using: :btree

  create_table "message_rooms", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "creater_id"
    t.integer  "created_id"
    t.boolean  "new_messages_exist"
    t.integer  "new_messages_count"
    t.integer  "last_sender_id"
    t.datetime "last_updated_time"
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "content"
    t.integer  "message_room_id"
    t.boolean  "checked",         default: false
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "user_id"
    t.integer  "circle_id"
    t.string   "content"
    t.integer  "notification_type"
    t.integer  "hold_user_id"
    t.integer  "blog_id"
    t.boolean  "checked",           default: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_categories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "priority"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                   default: "",    null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "introduce"
    t.string   "want_to_do"
    t.string   "hobby"
    t.string   "picture"
    t.string   "college"
    t.string   "department"
    t.string   "grade"
    t.string   "header_picture"
    t.string   "encrypted_password",      default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",         default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "birth_place"
    t.string   "home_place"
    t.string   "my_circle_atom"
    t.string   "career"
    t.string   "future"
    t.integer  "sex"
    t.text     "oppotunity"
    t.boolean  "new_messages_exist",      default: false
    t.integer  "new_messages_count"
    t.integer  "new_notifications_count"
    t.integer  "new_foots_count"
    t.boolean  "new_notifications_exist"
    t.boolean  "new_foots_exist"
    t.integer  "joining_circle_id"
    t.boolean  "first_facebook_login",    default: true
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
