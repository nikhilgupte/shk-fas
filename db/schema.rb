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

ActiveRecord::Schema.define(:version => 20090126164456) do

  create_table "ingredient_master", :id => false, :force => true do |t|
    t.string "code",          :limit => nil
    t.string "name",          :limit => nil
    t.string "cost",          :limit => nil
    t.string "line_location", :limit => nil
    t.string "user_entry",    :limit => nil
  end

  create_table "ingredient_prices", :force => true do |t|
    t.integer  "ingredient_id"
    t.string   "currency"
    t.float    "price"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ingredient_prices", ["ingredient_id"], :name => "index_ingredient_prices_on_ingredient_id"

  create_table "ingredients", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "product_id",                       :null => false
    t.float    "quantity",                         :null => false
    t.integer  "created_by_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "submitted_at"
    t.string   "location",            :limit => 1
    t.string   "priority",            :limit => 1
    t.float    "production_quantity"
  end

  add_index "orders", ["created_by_id"], :name => "index_orders_on_creator_id"
  add_index "orders", ["product_id"], :name => "index_orders_on_product_id"

  create_table "products", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",      :limit => 10, :null => false
    t.string   "email_address",               :null => false
    t.string   "password",      :limit => 50, :null => false
    t.string   "salt",          :limit => 8,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
