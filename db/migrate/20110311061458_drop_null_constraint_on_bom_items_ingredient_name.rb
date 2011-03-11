class DropNullConstraintOnBomItemsIngredientName < ActiveRecord::Migration
  def self.up
    change_column_null :bill_of_materials_items, :ingredient_name, true
  end

  def self.down
  end
end
