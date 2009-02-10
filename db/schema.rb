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

ActiveRecord::Schema.define(:version => 20090205091009) do

  create_table "_imaster", :id => false, :force => true do |t|
    t.string "code", :limit => nil
    t.string "name", :limit => nil
    t.string "cost", :limit => nil
    t.string "x",    :limit => nil
    t.string "y",    :limit => nil
  end

  create_table "_pmaster", :id => false, :force => true do |t|
    t.string "code",      :limit => nil
    t.string "name",      :limit => nil
    t.float  "sales_qty"
  end

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

  create_table "products", :force => true do |t|
    t.string   "code",                                      :null => false
    t.string   "name",                                      :null => false
    t.float    "quarterly_sales_quantity", :default => 0.0, :null => false
    t.string   "production_code"
    t.string   "string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tax_rates", :force => true do |t|
    t.string   "name",       :null => false
    t.float    "rate",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",   :limit => 10, :null => false
    t.string   "password",   :limit => 50, :null => false
    t.string   "salt",       :limit => 8,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
