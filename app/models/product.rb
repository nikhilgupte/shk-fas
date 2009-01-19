class Product < ActiveRecord::Base

  before_save :upper_case

  named_scope :live

  def long_name
    "#{code} - #{name}"
  end

  private
  def upper_case
    self.code = code.upcase
    self.name = name.upcase
  end
end
