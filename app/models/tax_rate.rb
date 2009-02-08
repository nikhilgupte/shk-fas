class TaxRate < ActiveRecord::Base

  def description() "#{name} (#{rate}%)" end
end
