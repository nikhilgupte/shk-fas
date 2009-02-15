class TaxRate < ActiveRecord::Base

  validates_presence_of :name, :rate
  validates_uniqueness_of :name, :allow_blank => true
  validates_numericality_of :rate, :allow_blank => true

  before_validation :fix_fields

  def description() "#{name} (#{rate}%)" end

  private
  def fix_fields
    self.name = name.upcase.strip rescue nil
  end
end
