class Product < ActiveRecord::Base

  before_save :fix_fields

  named_scope :live

  def long_name
    "#{code} - #{name}"
  end

  private
  def fix_fields
    self.code = code.upcase.trim rescue nil
    self.name = name.upcase.trim rescue nil
  end
end
