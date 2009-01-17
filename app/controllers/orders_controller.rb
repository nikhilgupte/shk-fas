class OrdersController < ApplicationController
  def index
    @title = "Orders"
    @order = Order.new
  end

  def create
    @order = @logged_in_user.orders.build params[:order]
    @order.save
    render :update do |page|
      if @order.errors.empty?
        page.insert_html :top, 'order_list', :partial => 'orders', :locals => {:order => @order}
        page.visual_effect :highlight, "o_#{@order.id}"
        @order = Order.new
      end
      page.replace 'order_form', :partial => 'form'
    end
  end

  def delete
    @logged_in_user.orders.delete(params[:id])
  end

  def export
    @orders = Order.all
    respond_to do |format|
      format.xml {render :xml => @orders.to_xml(:skip_types => true)}
      format.json {render :json => @orders.to_json}
      format.csv {}
    end
  end

  def auto_complete_for_order_product_name_or_code
    arg = params[:order][:product_name_or_code]
    arg.downcase!
    @products = Product.live.find(:all, :conditions => ['lower(name) like ? or lower(code) like ?', "#{arg}%", "#{arg}%"], :limit => 10)
    render :partial => 'products'
  end

end
