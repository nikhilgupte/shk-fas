class ProductsController < ApplicationController
  def get_quarterly_sales_quantity
    render :text => "#{Product.find(params[:id]).quarterly_sales_quantity} kg"
  end
end
