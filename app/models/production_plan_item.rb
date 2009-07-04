class ProductionPlanItem < ActiveRecord::Base

  belongs_to :product
  belongs_to :production_plan
  validates_presence_of :product_id
  (1..4).each do |i|
    validates_inclusion_of "quantity_#{i}", :within => 0..100000, :message => 'should under 100,000 Kgs.', :allow_blank => true
  end

  before_validation :fix_quantities

  def validate_on_create
    if errors.empty? && production_plan.submitted?
      errors.add_to_base 'Plan has been submitted. Cannot add any more items.'
    end
  end

  def percentage
    #quantity * 100.0 / production_plan.net_quantity
    10
  end

  def percentage_below_threshold?
    percentage < 10
  end

  private
  def fix_quantities
    (1..4).each{|i| self.send("quantity_#{i}=", 0) if self.send("quantity_#{i}").nil? }
  end
end