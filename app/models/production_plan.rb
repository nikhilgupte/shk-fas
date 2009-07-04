class ProductionPlan < ActiveRecord::Base
  FORECAST_TYPE = {:w => 'Weekly', :m => 'Monthly', :q => 'Quaterly', :a => 'Annual'}

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

  def net_quantity
    items.sum(:quantity)
  end

  def validate_items
    #errors.add_to_base('Item quantity must be atleast 10% of the net quantity.') if items.any?{|i| i.percentage_below_threshold?}
  end
end
