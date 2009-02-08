module Admin::IngredientsHelper
  def tax_rate_column(record) record.tax_rate.description if record.tax_rate end
  def custom_duty_column(record) record.custom_duty.description if record.tax_rate end
end

