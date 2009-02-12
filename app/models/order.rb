class Order < ActiveRecord::Base
  LOCATION = {:m => 'Mulund', :v => 'Vashiwali', :k => 'KEVA'}
  PRIORITY = {:u => 'Urgent', :l => 'Lot'}

  attr_accessor :product_name_or_code
  attr_protected :created_by_id

  belongs_to :created_by, :class_name => 'User', :foreign_key => :created_by_id
  belongs_to :product

  named_scope :pending, :conditions => "submitted_at is null", :order => 'created_at desc'
  named_scope :all, :order => 'created_at desc'

  validates_presence_of :product_id, :created_by_id
  validates_numericality_of :quantity, :production_quantity
  validates_inclusion_of :quantity, :within => 10..100000, :message => 'should be between 10 and 100,000 Kgs.'
  validates_inclusion_of :priority, :within => PRIORITY.keys.collect(&:to_s), :message => 'is not valid', :allow_blank => true
  validates_inclusion_of :location, :within => LOCATION.keys.collect(&:to_s), :message => 'is not valid', :allow_blank => true

  def validate_on_create
    t = created_by.orders.pending.find(:first, :conditions => ['product_id = ? and location <> ?', product_id, 'k'])
    if (location == 'k' && created_by.orders.pending.exists?(['product_id = ? and location = ?', product_id, 'k'])) \
        || (location != 'k' && created_by.orders.pending.exists?(['product_id = ? and location != ?', product_id, 'k']))
      errors.add_to_base('Duplicate order detected. Please update the existing order!')
    end
  end

  def validate
    errors.add(:production_quantity, 'must be greater than or equal to the Order Qty') if production_quantity < quantity
  end

  before_validation :set_default_production_qty, :fix_fields

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
    self.production_quantity = self.quantity if self.production_quantity.nil? # || self.production_quantity == 0
  end

  def fix_fields
    self.location = '' unless self.location
    self.priority = '' unless self.priority
  end
end
