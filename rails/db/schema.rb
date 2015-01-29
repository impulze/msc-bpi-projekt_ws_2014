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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150128082311) do

  create_table "descriptions", :force => true do |t|
    t.string "string",                 :null => false
    t.string "language", :limit => 35, :null => false
  end

  create_table "products", :force => true do |t|
    t.integer  "gtin",                        :null => false
    t.string   "target_market", :limit => 80, :null => false
    t.integer  "provider_gln",                :null => false
    t.string   "provider_name",               :null => false
    t.string   "ttl",                         :null => false
    t.string   "variant_desc",                :null => false
    t.string   "variant_dtime",               :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

end
