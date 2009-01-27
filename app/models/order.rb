class Order < ActiveRecord::Base
  LOCATION = {:m => 'Mulund', :v => 'Vashi'}
  PRIORITY = {:u => 'Urgent', :l => 'Lot'}

  attr_accessor :product_name_or_code
  attr_protected :created_by_id

  belongs_to :user, :foreign_key => :created_by_id
  belongs_to :product

  named_scope :pending, :conditions => "submitted_at is null", :order => 'created_at desc'
  named_scope :all, :order => 'created_at desc'

  validates_presence_of :product_id, :created_by_id
  validates_numericality_of :quantity, :production_quantity
  validates_inclusion_of :quantity, :production_quantity, :within => 10..100000, :message => 'should be between 10 and 100,000 Kgs.'
  validates_inclusion_of :priority, :within => PRIORITY.keys.collect(&:to_s), :message => 'is not valid', :allow_blank => true
  validates_inclusion_of :location, :within => LOCATION.keys.collect(&:to_s), :message => 'is not valid', :allow_blank => true

  before_validation :set_default_production_qty

  def location_text
    LOCATION[location.to_sym] rescue '-'
  end

  def priority_text
    PRIORITY[priority.to_sym] rescue '-'
  end

  def self.submissions
    Order.connection.execute('select submitted_at, created_by_id, count(*) as count from orders where submitted_at is not null group by submitted_at, created_by_id order by submitted_at desc')
  end

  private
  def set_default_production_qty
    self.production_quantity = self.quantity if self.production_quantity.nil? || self.production_quantity == 0
  end
end
