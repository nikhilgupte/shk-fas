class CreateIngredients < ActiveRecord::Migration
  def self.up
    create_table :ingredients do |t|
      t.string :code, :null => false
      t.string :name, :null => false
      
      t.timestamps
    end
    execute %{create unique index index_ingredients_on_code on ingredients(lower(code))}
    execute %{create unique index index_ingredients_on_name on ingredients(lower(name))}
  end

  def self.down
    drop_table :ingredients
  end
end
