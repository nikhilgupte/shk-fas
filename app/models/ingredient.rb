class Ingredient < ActiveRecord::Base

  validates_presence_of :name, :code
  validates_presence_of :custom_duty, :tax_rate, :unless => Proc.new { |i| i.import_mode }
  validates_uniqueness_of :code, :allow_blank => true

  has_many :prices, :class_name => 'IngredientPrice', :order => 'created_at'
  belongs_to :tax_rate
  belongs_to :custom_duty

  named_scope :live, :order => 'name asc'
  named_scope :updated_since, lambda { |since| {
      :select => 'ingredients.*',
      :joins => 'inner join ingredient_prices ip1 on ingredients.id = ip1.ingredient_id left outer join ingredient_prices ip2 on ingredients.id = ip2.ingredient_id and ip1.created_at < ip2.created_at',
      :conditions => ['ip2.id is null and ip1.created_at::date >= ?', since], :order => 'name asc'
  }}

  before_validation :fix_fields

  attr_accessor :import_mode

  def latest_price
    prices.last
  end

  def self.find_by_code(code)
    find(:first, :conditions => ["lower(code) = ?", code.strip.downcase])
  end

  def has_tax_rate_and_custom_duty?
    not(tax_rate.nil? || custom_duty.nil?)
  end

  private
  def fix_fields
    self.code = code.upcase.strip rescue nil
    self.name = name.upcase.strip rescue nil
  end
end
