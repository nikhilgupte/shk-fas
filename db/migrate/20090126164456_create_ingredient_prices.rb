class CreateIngredientPrices < ActiveRecord::Migration
  extend MigrationHelpers
  def self.up
    create_table :ingredient_prices do |t|
      t.integer :ingredient_id
      t.float :price_in_inr
      t.float :price_in_usd
      t.float :price_in_eur
      t.integer :user_id

      t.timestamp :created_at, :null => false
    end
    add_index :ingredient_prices, :ingredient_id
    foreign_key(:ingredient_prices, :ingredient_id, :ingredients, true)
  end

  def self.down
    drop_table :ingredient_prices
  end
end
