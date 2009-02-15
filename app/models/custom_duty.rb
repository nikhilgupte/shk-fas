class CustomDuty < ActiveRecord::Base

  validates_presence_of :name, :duty
  validates_uniqueness_of :name, :allow_blank => true
  validates_numericality_of :duty, :allow_blank => true

  before_validation :fix_fields

  def description() "#{name} (#{duty}%)" end

  private
  def fix_fields
    self.name = name.upcase.strip rescue nil
  end
end
