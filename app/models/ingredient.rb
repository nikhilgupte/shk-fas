class Ingredient < ActiveRecord::Base

  has_many :prices, :class_name => 'IngredientPrice', :order => 'created_at'
  belongs_to :tax_rate
  belongs_to :custom_duty

  named_scope :live, :order => 'name asc'
  named_scope :updated_since, lambda { |since| {
      :select => 'ingredients.*',
      :joins => 'inner join ingredient_prices ip1 on ingredients.id = ip1.ingredient_id left outer join ingredient_prices ip2 on ingredients.id = ip2.ingredient_id and ip1.created_at < ip2.created_at',
      :conditions => ['ip2.id is null and ip1.created_at::date >= ?', since], :order => 'name asc'
  }}

  def latest_price
    prices.last
  end

  private
  def upper_case
    self.code = code.upcase
    self.name = name.upcase
  end
end
