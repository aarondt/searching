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

ActiveRecord::Schema.define(version: 20160806004802) do

  create_table "bottles", force: :cascade do |t|
    t.string   "name"
    t.integer  "shop_id"
    t.decimal  "price"
    t.string   "vinyard"
    t.string   "vintage"
    t.string   "grape"
    t.string   "country"
    t.string   "product_url"
    t.string   "image_url"
    t.string   "category"
    t.string   "general_info"
    t.decimal  "price_per_litre"
    t.string   "inhalt"
    t.string   "price_per_litre_string"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "searches", force: :cascade do |t|
    t.string   "keywords"
    t.string   "category"
    t.decimal  "min_price"
    t.decimal  "max_price"
    t.decimal  "vintage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "name"
    t.string   "shop_logo"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.decimal  "versandkosten"
    t.integer  "mindest_bestellmenge"
    t.decimal  "versandkostenfrei_ab_betrag"
    t.integer  "versandkostenfrei_ab_menge"
    t.decimal  "verpackungsrabatt"
    t.integer  "verpackungsrabatt_menge"
    t.decimal  "mengenrabatt"
    t.integer  "mengenrabatt_menge"
  end

end
