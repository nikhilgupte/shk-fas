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
    if request.post?
      @export = Export.new params[:export]
      if @export.valid?
        @orders = Order.all.find(:all, :conditions => ['created_at >= ? and created_at <= ?', @export.from - 1.day, @export.to])
        response.headers['Content-Type'] = 'application/force-download'
        response.headers['Content-Disposition'] = "attachment; filename=\"orders-#{@export.from}-to-#{@export.to}.csv\""
      end
    end
    @export = Export.new(:from => 2.days.ago, :to => 1.day.ago) unless @export
    @title = 'Export'
  end

  def auto_complete_for_order_product_name_or_code
    arg = params[:order][:product_name_or_code]
    arg.downcase!
    @products = Product.live.find(:all, :conditions => ['lower(name) like ? or lower(code) like ?', "#{arg}%", "#{arg}%"], :limit => 10)
    render :partial => 'products'
  end

end
