class Product < ActiveRecord::Base

  validates_presence_of :name, :code
  validates_uniqueness_of :code, :allow_blank => true
  validates_numericality_of :quarterly_sales_quantity

  before_validation :fix_fields

  named_scope :live

  def long_name
    "#{code} - #{name}"
  end

  private
  def fix_fields
    self.code = code.upcase.strip rescue nil
    self.production_code = production_code.upcase.strip rescue nil
    self.name = name.upcase.strip rescue nil
  end
end
