class OrdersController < ApplicationController
  def index
    @title = "Pending Orders"
    @order = Order.new
  end

  def create
    @order = @logged_in_user.orders.build params[:order]
    @order.save
    render :update do |page|
      if @order.errors.empty?
        page.insert_html :top, 'order_list', :partial => 'order', :locals => {:order => @order}
        page.visual_effect :highlight, "o_#{@order.id}"
        page.call 'order_added'
        @order = Order.new
      end
      page.replace 'order_form', :partial => 'new'
    end
  end

  def destroy
    @logged_in_user.orders.find(params[:id]).destroy
  end

  def edit
    @order = @logged_in_user.orders.find(params[:id])
    render :update do |p|
      p.replace "o_#{@order.id}", :partial => 'edit'
    end
  end

  def update
    @order = @logged_in_user.orders.find(params[:id])
    if @order.update_attributes params[:order]
      render :update do |page|
        page.replace "o_#{@order.id}", :partial => 'order', :locals => {:order => @order}
        page.visual_effect :highlight, "o_#{@order.id}"
      end
    else
      render :update do |page|
        page.replace "o_#{@order.id}", :partial => 'edit'
      end
    end
  end

  def submit
    @logged_in_user.orders.pending.update_all(['submitted_at = ?', Time.now])
    flash[:notice] = "Pending orders submitted!"
    redirect_to orders_path
  end

  def export
    if request.format == Mime::CSV
        submitted_at = DateTime.parse params[:submitted_at]
        @orders = Order.all.find(:all, :conditions => ['submitted_at >= ? and submitted_at < ? and created_by_id = ?', submitted_at, submitted_at + 1.second, params[:user_id].to_i])
        response.headers['Content-Type'] = 'application/force-download'
        response.headers['Content-Disposition'] = "attachment; filename=\"orders-#{submitted_at.to_s(:datetime).gsub(/\W/,'-')}-#{User.find(params[:user_id]).username}.csv\""
        return render :text => @orders.collect{|o| [o.id, o.product.code, o.quantity, o.production_quantity, o.location, o.priority].to_csv}.join()
    else
      @title = 'Export'
      @submissions = Order.submissions
    end
  end

  def auto_complete_for_order_product_name_or_code
    arg = params[:order][:product_name_or_code]
    arg.downcase!
    @products = Product.live.find(:all, :conditions => ['lower(name) like ? or lower(code) like ?', "#{arg}%", "#{arg}%"], :limit => 10)
    render :partial => 'products'
  end

end
