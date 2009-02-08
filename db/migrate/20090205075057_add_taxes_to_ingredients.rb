class AddTaxesToIngredients < ActiveRecord::Migration
  def self.up
    add_column :ingredients, :tax_rate_id, :integer
    add_column :ingredients, :custom_duty_id, :integer
  end

  def self.down
    remove_column :ingredients, :tax_rate_id
    remove_column :ingredients, :custom_duty_id
  end
end
