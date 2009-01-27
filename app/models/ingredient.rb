class Ingredient < ActiveRecord::Base

  has_many :prices, :class_name => 'IngredientPrice'

  named_scope :live, :order => 'name asc'

  private
  def upper_case
    self.code = code.upcase
    self.name = name.upcase
  end
end
