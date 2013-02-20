module OrdersHelper
  def standard_quantity(product)
    return '<i class="tip">Choose Product</i>' if product.nil?
    if product.formulation.present? && product.formulation.standard_quantity.present?
      return "#{product.formulation_standard_quantity} gms"
    else
      'N/A'
    end
  end


end
