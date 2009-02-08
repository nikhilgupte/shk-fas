class CustomDuty < ActiveRecord::Base

  def description() "#{name} (#{duty}%)" end
end
