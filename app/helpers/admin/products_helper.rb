module Admin::ProductsHelper
  def formulation_column(record)
    if formulation = record.formulation
      formulation.name_with_code
    else
      "N/A"
    end
  end
end

