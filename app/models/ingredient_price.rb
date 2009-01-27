class IngredientPrice < ActiveRecord::Base
  validates_presence_of :price, :currency
  validates_numericality_of :price, :greater_than_or_equal_to => 0, :allow_blank => true

  named_scope :latest,
    :select => 'ingredient_prices.*',
    :joins => 'left outer join ingredient_prices p2 on ingredient_prices.ingredient_id = p2.ingredient_id and ingredient_prices.currency = p2.currency and ingredient_prices.created_at < p2.created_at',
    :conditions => 'p2.id is null',
    :order => 'ingredient_prices.currency'
end
