class ProductionPlanItem < ActiveRecord::Base

  MAXIMUM_QUANTITY_PERCENTAGE = 10

  belongs_to :product
  belongs_to :production_plan
  validates_presence_of :product_id
  (1..4).each do |i|
    validates_inclusion_of "quantity_#{i}", :within => 0..100000, :message => 'should be under 100,000 Kgs.', :allow_blank => true
  end

  before_validation :fix_quantities

  def validate_on_create
    if errors.empty? && production_plan.submitted?
      errors.add_to_base 'Plan has been submitted. Cannot add any more items.'
    end
  end

  def quantity_above_threshold?(qty_index)
    quantity(qty_index) > 0 && percentage(qty_index) > MAXIMUM_QUANTITY_PERCENTAGE
  end

  def percentage(qty_index)
    quantity(qty_index) * 100.0 / production_plan.net_quantity(qty_index)
  end

  def quantity(qty_index)
    send("quantity_#{qty_index}")
  end

  private
  def fix_quantities
    (1..4).each{|i| self.send("quantity_#{i}=", 0) if self.send("quantity_#{i}").nil? }
  end

end
