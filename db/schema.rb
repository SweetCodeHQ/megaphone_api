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

ActiveRecord::Schema[7.0].define(version: 2023_02_04_143326) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abstracts", force: :cascade do |t|
    t.bigint "topic_id", null: false
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_abstracts_on_topic_id"
  end

  create_table "entities", force: :cascade do |t|
    t.string "url", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entity_markets", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "market_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_entity_markets_on_entity_id"
    t.index ["market_id"], name: "index_entity_markets_on_market_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "word", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "search_count", default: 1
  end

  create_table "market_keywords", force: :cascade do |t|
    t.bigint "market_id", null: false
    t.bigint "keyword_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_market_keywords_on_keyword_id"
    t.index ["market_id"], name: "index_market_keywords_on_market_id"
  end

  create_table "markets", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string "text", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "submitted", default: false
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "user_entities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_user_entities_on_entity_id"
    t.index ["user_id"], name: "index_user_entities_on_user_id"
  end

  create_table "user_keywords", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "keyword_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_user_keywords_on_keyword_id"
    t.index ["user_id"], name: "index_user_keywords_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.boolean "is_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_blocked", default: false
    t.integer "login_count", default: 0
    t.integer "clicked_generate_count", default: 0
    t.integer "industry", default: 0
  end

  add_foreign_key "abstracts", "topics"
  add_foreign_key "entity_markets", "entities"
  add_foreign_key "entity_markets", "markets"
  add_foreign_key "market_keywords", "keywords"
  add_foreign_key "market_keywords", "markets"
  add_foreign_key "topics", "users"
  add_foreign_key "user_entities", "entities"
  add_foreign_key "user_entities", "users"
  add_foreign_key "user_keywords", "keywords"
  add_foreign_key "user_keywords", "users"
end
