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

ActiveRecord::Schema.define(version: 20170214141447) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blogs", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "circle_id"
    t.integer  "author_id"
    t.string   "picture"
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
  end

  add_index "circle_categories", ["category_id"], name: "index_circle_categories_on_category_id", using: :btree
  add_index "circle_categories", ["circle_id"], name: "index_circle_categories_on_circle_id", using: :btree

  create_table "circles", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "name"
    t.string   "description"
    t.string   "picture"
    t.string   "header_picture"
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

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "member_id"
    t.integer  "circle_id"
  end

  add_index "memberships", ["circle_id"], name: "index_memberships_on_circle_id", using: :btree
  add_index "memberships", ["member_id", "circle_id"], name: "index_memberships_on_member_id_and_circle_id", unique: true, using: :btree
  add_index "memberships", ["member_id"], name: "index_memberships_on_member_id", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "introduce"
    t.string   "want_to_do"
    t.string   "hobby"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "picture"
    t.string   "college"
    t.string   "department"
    t.integer  "grade"
    t.string   "header_picture"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
