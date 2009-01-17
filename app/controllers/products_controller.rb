class ProductsController < ApplicationController
  auto_complete_for :product, :code

  def index
    @title = "Orders"
  end

  def nikhil
    render :text => 'nik'
  end

end
