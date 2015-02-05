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

ActiveRecord::Schema.define(:version => 21) do

  create_table "basic_product_informations", :force => true do |t|
    t.integer "product_data_record_id"
    t.integer "gpc_category_code",      :null => false
  end

  create_table "brand_name_information_internationals", :force => true do |t|
    t.string  "string",                    :limit => 70, :null => false
    t.string  "codelist_version",          :limit => 35
    t.string  "language",                  :limit => 80, :null => false
    t.integer "brand_name_information_id"
  end

  create_table "brand_name_information_locals", :force => true do |t|
    t.string  "string",                    :limit => 70, :null => false
    t.integer "brand_name_information_id"
  end

  create_table "brand_name_informations", :force => true do |t|
    t.integer "basic_product_information_id"
  end

  create_table "communication_channel_types", :force => true do |t|
    t.string  "value",                              :limit => 200, :null => false
    t.string  "name",                               :limit => 200
    t.integer "communication_channel_code_type_id"
    t.integer "packaging_signature_line_id"
  end

  create_table "consumer_marketing_descriptions", :force => true do |t|
    t.string  "string",                       :limit => 2500, :null => false
    t.string  "codelist_version",             :limit => 35
    t.string  "language",                     :limit => 80,   :null => false
    t.integer "basic_product_information_id"
  end

  create_table "food_and_beverage_ingredient_informations", :force => true do |t|
    t.integer "product_data_record_id"
  end

  create_table "food_and_beverage_ingredient_names", :force => true do |t|
    t.string  "string",                          :limit => 70, :null => false
    t.string  "codelist_version",                :limit => 35
    t.string  "language",                        :limit => 80, :null => false
    t.integer "food_and_beverage_ingredient_id"
  end

  create_table "food_and_beverage_ingredient_statements", :force => true do |t|
    t.string  "string",                                      :limit => 2500, :null => false
    t.string  "codelist_version",                            :limit => 35
    t.string  "language",                                    :limit => 80,   :null => false
    t.integer "food_and_beverage_ingredient_information_id"
  end

  create_table "food_and_beverage_ingredients", :force => true do |t|
    t.integer "food_and_beverage_ingredient_information_id"
    t.integer "country_code_type_id"
    t.integer "sequence"
  end

  create_table "gs1_code_types", :force => true do |t|
    t.string "string",           :limit => 80, :null => false
    t.string "codelist_version", :limit => 35
  end

  create_table "image_links", :force => true do |t|
    t.string  "url",                          :limit => 2500, :null => false
    t.integer "height"
    t.integer "width"
    t.integer "measurement_type_id"
    t.integer "basic_product_information_id"
    t.integer "image_type_code_type_id"
    t.integer "language_type_code_type_id"
  end

  create_table "measurement_types", :force => true do |t|
    t.string  "unit_code",        :limit => 80, :null => false
    t.string  "codelist_version", :limit => 35
    t.integer "value"
  end

  create_table "packaging_signature_lines", :force => true do |t|
    t.string  "contact_name",                    :limit => 200, :null => false
    t.string  "contact_address",                 :limit => 500, :null => false
    t.integer "gln",                                            :null => false
    t.integer "party_contact_role_code_type_id"
    t.integer "basic_product_information_id"
  end

  create_table "product_data_records", :force => true do |t|
    t.string  "variant_effective_datetime", :null => false
    t.integer "product_id"
  end

  create_table "product_information_links", :force => true do |t|
    t.string  "url",                                   :limit => 2500, :null => false
    t.integer "basic_product_information_id"
    t.integer "product_information_type_code_type_id"
    t.integer "language_type_code_type_id"
  end

  create_table "product_names", :force => true do |t|
    t.string  "string",                       :limit => 80, :null => false
    t.string  "codelist_version",             :limit => 35
    t.string  "language",                     :limit => 80, :null => false
    t.integer "basic_product_information_id"
  end

  create_table "product_quantity_informations", :force => true do |t|
    t.integer "product_data_record_id"
    t.integer "measurement_type_id"
    t.float   "percentage_of_alcohol_by_volume"
  end

  create_table "production_variant_descriptions", :force => true do |t|
    t.string  "string",                 :limit => 70, :null => false
    t.string  "codelist_version",       :limit => 35
    t.string  "language",               :limit => 80, :null => false
    t.integer "product_data_record_id"
  end

  create_table "products", :force => true do |t|
    t.integer "gtin",             :null => false
    t.integer "provider_gln",     :null => false
    t.string  "provider_name",    :null => false
    t.string  "ttl",              :null => false
    t.integer "target_market_id"
  end

  create_table "regulated_product_names", :force => true do |t|
    t.string  "string",                       :limit => 500, :null => false
    t.string  "codelist_version",             :limit => 35
    t.string  "language",                     :limit => 80,  :null => false
    t.integer "basic_product_information_id"
  end

end
