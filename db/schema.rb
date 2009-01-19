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

ActiveRecord::Schema.define(:version => 20090116092505) do

  create_table "orders", :force => true do |t|
    t.integer  "product_id", :null => false
    t.float    "quantity",   :null => false
    t.integer  "creator_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["creator_id"], :name => "index_orders_on_creator_id"
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
