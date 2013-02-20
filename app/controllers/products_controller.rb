class ProductsController < ApplicationController
  include OrdersHelper

  def get_formulation_standard_qty
    render :text => standard_quantity(Product.find(params[:id]))
  end
end
