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

ActiveRecord::Schema.define(version: 20160717013324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "classifications", force: :cascade do |t|
    t.string   "status"
    t.float    "available"
    t.float    "block_page"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.json     "transaction_data"
  end

  create_table "classifiers", force: :cascade do |t|
    t.string   "name"
    t.float    "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "type"
  end

  create_table "transaction_requests", force: :cascade do |t|
    t.integer  "timeout"
    t.string   "request_headers"
    t.string   "asn"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "transaction_responses", force: :cascade do |t|
    t.integer  "status_code"
    t.text     "raw_results"
    t.string   "errors_encountered"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
