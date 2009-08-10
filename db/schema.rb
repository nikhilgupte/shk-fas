# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090810104012) do

  create_table "_imaster", :force => true do |t|
    t.string "code", :limit => nil
    t.string "name", :limit => nil
    t.float  "cost"
  end

  create_table "_production_codes", :id => false, :force => true do |t|
    t.string "b_code", :limit => nil
    t.string "name",   :limit => nil
    t.string "p_code", :limit => nil
  end

  create_table "bill_of_materials", :force => true do |t|
    t.integer  "production_plan_id", :null => false
    t.integer  "created_by_id",      :null => false
    t.string   "remarks"
    t.datetime "created_at"
  end

  add_index "bill_of_materials", ["created_by_id"], :name => "index_bill_of_materials_on_created_by_id"
  add_index "bill_of_materials", ["production_plan_id"], :name => "index_bill_of_materials_on_production_plan_id"

  create_table "bill_of_materials_items", :force => true do |t|
    t.integer "bill_of_materials_id", :null => false
    t.integer "ingredient_id"
    t.string  "ingredient_name",      :null => false
    t.string  "ingredient_code",      :null => false
    t.float   "quantity_1",           :null => false
    t.float   "quantity_2",           :null => false
    t.float   "quantity_3",           :null => false
    t.float   "quantity_4",           :null => false
  end

  add_index "bill_of_materials_items", ["bill_of_materials_id"], :name => "index_bill_of_materials_items_on_bill_of_materials_id"
  add_index "bill_of_materials_items", ["ingredient_id"], :name => "index_bill_of_materials_items_on_ingredient_id"

  create_table "currencies", :force => true do |t|
    t.string "name"
    t.float  "inr_value"
  end

  create_table "custom_duties", :force => true do |t|
    t.string   "name",       :null => false
    t.float    "duty",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "export_logs", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
  end

  create_table "formulations", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "code",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredient_prices", :force => true do |t|
    t.integer  "ingredient_id"
    t.float    "price_in_inr"
    t.float    "price_in_usd"
    t.float    "price_in_eur"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
  end

  add_index "ingredient_prices", ["ingredient_id"], :name => "index_ingredient_prices_on_ingredient_id"

  create_table "ingredients", :force => true do |t|
    t.string   "code",           :null => false
    t.string   "name",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tax_rate_id"
    t.integer  "custom_duty_id"
  end

  create_table "orders", :force => true do |t|
    t.integer  "product_id",                       :null => false
    t.float    "quantity",                         :null => false
    t.float    "production_quantity",              :null => false
    t.integer  "created_by_id",                    :null => false
    t.string   "location",            :limit => 1
    t.string   "priority",            :limit => 1
    t.datetime "submitted_at"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["created_by_id"], :name => "index_orders_on_created_by_id"
  add_index "orders", ["product_id"], :name => "index_orders_on_product_id"

  create_table "permissions", :force => true do |t|
    t.integer "user_id",   :null => false
    t.string  "module",    :null => false
    t.string  "operation", :null => false
  end

  add_index "permissions", ["module", "operation", "user_id"], :name => "index_permissions_on_user_id_and_module_and_operation", :unique => true

  create_table "production_plan_items", :force => true do |t|
    t.integer  "production_plan_id", :null => false
    t.integer  "product_id",         :null => false
    t.float    "quantity_1",         :null => false
    t.float    "quantity_2",         :null => false
    t.float    "quantity_3",         :null => false
    t.float    "quantity_4",         :null => false
    t.datetime "created_at"
  end

  add_index "production_plan_items", ["product_id"], :name => "index_production_plan_items_on_product_id"
  add_index "production_plan_items", ["production_plan_id"], :name => "index_production_plan_items_on_production_plan_id"

  create_table "production_plans", :force => true do |t|
    t.integer  "created_by_id", :null => false
    t.string   "forecast_type", :null => false
    t.string   "location"
    t.string   "remarks"
    t.datetime "submitted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "column_labels"
  end

  add_index "production_plans", ["created_by_id"], :name => "index_production_plans_on_created_by_id"

  create_table "products", :force => true do |t|
    t.string   "code",                                      :null => false
    t.string   "name",                                      :null => false
    t.float    "quarterly_sales_quantity", :default => 0.0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "formulation_id"
  end

  add_index "products", ["formulation_id"], :name => "index_products_on_formulation_id"

  create_table "tax_rates", :force => true do |t|
    t.string   "name",       :null => false
    t.float    "rate",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",          :limit => 10,                    :null => false
    t.string   "password",          :limit => 50,                    :null => false
    t.string   "salt",              :limit => 8,                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "disabled",                        :default => false, :null => false
    t.string   "full_name",                                          :null => false
    t.string   "email_address",                                      :null => false
    t.datetime "last_logged_in_at"
    t.integer  "access_level",                    :default => 0,     :null => false
  end

end
