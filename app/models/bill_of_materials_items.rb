class BillOfMaterialsItems < ActiveRecord::Base

  #validates_inclusion_of :quantity, :within => 1..100000, :message => 'should be between 1 and 100,000 Kgs.'

  belongs_to :bill_of_materials

  before_create :associate_ingredient
  before_validation :fix_quantities

  def in_db?
    ! ingredient_id.nil? 
  end

  private
  def associate_ingredient
    if ingredient = Ingredient.find_by_code(self.ingredient_code)
      self.ingredient_id = ingredient.id
    end
  end

  def fix_quantities
    (1..4).each{|i| self.send("quantity_#{i}=", 0) if self.send("quantity_#{i}").nil? }
  end
end
