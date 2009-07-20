class ProductionPlan < ActiveRecord::Base
  FORECAST_TYPE = {:w => 'Weekly', :m => 'Monthly', :q => 'Quaterly', :a => 'Annual'}
  MINIMUM_NUMBER_OF_PRODUCTS = RAILS_ENV == "production" ? 10 : 5

  validates_presence_of :forecast_type
  validates_length_of :remarks, :maximum => 255

  attr_protected :created_by_id

  has_many :items, :class_name => "ProductionPlanItem", :order => 'id desc'
  has_one :bill_of_materials
  belongs_to :created_by, :class_name => "User"

  named_scope :recent, :order => 'updated_at desc'

  def forecast
    FORECAST_TYPE[forecast_type.to_sym]
  end

  def location_name
    Order::LOCATION[location.to_sym] rescue "N/A"
  end

  def submitted?
    !submitted_at.nil?
  end

  def net_quantity(quantity_index)
    items.sum("quantity_#{quantity_index}")
  end

  def validate_items
    error = false
    items.each do |item|
      (1..4).each do |i|
        if item.quantity_below_threshold?(i)
          item.errors.add("quantity_#{i}", "should be above #{MINIMUM_QUANTITY_PERCENTAGE}%")
          error = true
        end
      end
    end
    errors.add_to_base('Item quantity must be atleast 10% of the net quantity.') if error
    (1..4).each do |i|
      errors.add_to_base("Qty Column #{i} should have at least #{MINIMUM_NUMBER_OF_PRODUCTS} of products.") if items.count(:conditions => "quantity_#{i} > 0") < MINIMUM_NUMBER_OF_PRODUCTS
    end
  end
end
