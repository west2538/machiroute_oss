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

ActiveRecord::Schema.define(version: 2019_05_14_063155) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "auths", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string "body"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_uid"
    t.string "mstdn_status"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "endpoint", null: false
    t.string "p256dh", null: false
    t.string "auth", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "mastodon_clients", force: :cascade do |t|
    t.string "domain"
    t.string "client_id"
    t.string "client_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id"
    t.integer "notified_by_id"
    t.integer "post_id"
    t.string "notified_type"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notified_by_id"], name: "index_notifications_on_notified_by_id"
    t.index ["post_id"], name: "index_notifications_on_post_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "post_uid"
    t.integer "likes_count"
    t.string "placename"
    t.string "description"
    t.float "latitude"
    t.float "longitude"
    t.integer "bookisbn"
    t.string "booktitle"
    t.string "bookpublisher"
    t.string "bookauthor"
    t.string "bookpubdate"
    t.string "bookcover"
    t.string "bookplace"
    t.string "newsurl"
    t.string "newstitle"
    t.string "newsimage"
    t.string "stationname"
    t.integer "user_id"
    t.date "scenario_start"
    t.date "scenario_end"
    t.string "mstdn_status"
    t.integer "comments_count", default: 0, null: false
    t.integer "saves_count", default: 0, null: false
    t.index ["comments_count"], name: "index_posts_on_comments_count"
    t.index ["created_at"], name: "index_posts_on_created_at"
  end

  create_table "qroutes", force: :cascade do |t|
    t.integer "post_id"
    t.string "qplacename"
    t.string "qdescription"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "provider"
    t.string "token"
    t.integer "level"
    t.integer "exp"
    t.integer "hp"
    t.string "avatar"
    t.string "display_name"
    t.integer "machika_token"
    t.string "instance_title"
    t.boolean "online", default: true
    t.datetime "online_at"
    t.string "shogo"
    t.string "note"
    t.text "fields"
    t.string "fields1_name"
    t.string "fields1_value"
    t.string "fields2_name"
    t.string "fields2_value"
    t.string "fields3_name"
    t.string "fields3_value"
    t.string "fields4_name"
    t.string "fields4_value"
    t.string "twitter_screenname"
    t.integer "since_id"
  end

end
