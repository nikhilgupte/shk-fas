class Ingredient < ActiveRecord::Base

  has_many :prices, :class_name => 'IngredientPrice'

  named_scope :live, :order => 'name asc'

  def price(currency)
    prices.latest.find(:first, :conditions => ['ingredient_prices.currency = ?', currency]).price rescue nil
  end

  private
  def upper_case
    self.code = code.upcase
    self.name = name.upcase
  end
end
