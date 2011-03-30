class ProductionPlansController < ApplicationController

  def new
    @production_plan = ProductionPlan.new
  end

  def create
    @production_plan = @logged_in_user.production_plans.build params[:production_plan]
    if @production_plan.save
      return redirect_to production_plan_path(@production_plan)
    else
      render :action => :new
    end
  end

  def copy
    @production_plan = ProductionPlan.find params[:id]
    new_plan = @production_plan.copy(@logged_in_user)
    flash[:notice] = "Production Plan created from Plan ##{@production_plan.id}"
    return redirect_to edit_production_plan_path(new_plan)
  end

  def edit
    if(@production_plan = ProductionPlan.find params[:id]).editable?
      @title = "Edit Production Plan ##{@production_plan.id}"
      render :action => :new
    else
      flash[:notice] = "Production Plan ##{@production_plan.id} cannot be edited!"
      return redirect_to production_plan_path(@production_plan)
    end
  end

  def destroy
    if (@production_plan = ProductionPlan.find params[:id]).deletable?
      @production_plan.destroy
      flash[:notice] = "Production Plan ##{@production_plan.id} deleted!"
      return redirect_to production_plans_path
    else
      flash[:notice] = "Production Plan ##{@production_plan.id} cannot be deleted!"
      return redirect_to production_plan_path(@production_plan)
    end
  end

  def update
    @production_plan = ProductionPlan.find params[:id]
    if @production_plan.update_attributes params[:production_plan]
      flash[:notice] = 'Production plan updated'
      return redirect_to production_plan_path(@production_plan)
    end
    render :action => :new
  end

  def show
    @production_plan = ProductionPlan.find params[:id]
    @title = "Production Plan ##{@production_plan.id}"
    respond_to do |f|
      f.html {}
      f.csv {
        items = @production_plan.items.map do |item|
          arr = [
            ["Product Code", item.product.code],
            ["Product Name", item.product.name],
            ["Production Code", item.product.production_code],
          ]
          (1..4).each do |i|
            arr << ["QTY #{i}", item.send("quantity_#{i}")]
          end
          arr
        end
        send_data items.to_csv(:encoding => 'u'),
          { :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=fas_production_plan_#{@production_plan.id}.csv" }
      }
    end
  end

  def bom
    @production_plan = ProductionPlan.find params[:id]
    @title = "Production Plan ##{@production_plan.id}: Bill of Materials"
    respond_to do |f|
      f.html {}
      f.csv {
        bom_items = @production_plan.bill_of_materials.items.collect do |item|
          [
            ["Ingredient Name", item.ingredient_name], ["Ingredient Code", item.ingredient_code]
          ].tap do |a|
            4.times do |i|
              a << ["Qty#{i+1}", item.send("quantity_#{i+1}")]
            end
          end
        end
        send_data bom_items.to_csv(:encoding => 'u'),
          { :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=\"fas-bom-#{@production_plan.id}.csv\"" }
      }
    end
  end

  def submit
    @production_plan = ProductionPlan.find params[:id]
    @production_plan.validate_items
    if @production_plan.errors.empty?
      @production_plan.update_attribute(:submitted_at, Time.now)
      flash[:notice] = 'Production plan submitted'
      return redirect_to production_plan_path(@production_plan)
    end
    render :action => :show
  end

  def auto_complete_for_item_product_name_or_code
    #arg = params[:item][:product_name_or_code]
    arg = params[:product_name_or_code]
    arg.downcase!
    @products = Product.live.find(:all, :conditions => ['lower(name) like ? or lower(code) like ?', "%#{arg}%", "#{arg}%"], :limit => 10)
    render :partial => 'orders/products.html.erb'
  end

  def upload_bom
    @production_plan = ProductionPlan.find params[:id]
    @bill_of_materials = @production_plan.build_bill_of_materials params[:bill_of_materials]
    @bill_of_materials.created_by_id = @logged_in_user.id
    begin
    FasterCSV.parse(params[:bill_of_materials_file].read.chop, {:headers =>true,:skip_blanks => true}) do |row|
      item = @bill_of_materials.items.build(:ingredient_code => row[0])
      (1..4).each do |i|
        item.send("quantity_#{i}=", row[i])
      end
    end
    rescue
    end
    if @bill_of_materials.save
      return redirect_to bom_production_plan_path(@production_plan)
    end
    render :action => :bom
  end

  def delete_bom
    @production_plan = ProductionPlan.find params[:id]
    @production_plan.bill_of_materials.destroy
    return redirect_to bom_production_plan_path(@production_plan)
  end

  def edit_labels
    @production_plan = ProductionPlan.find params[:id]
    render :update do |page|
      page.replace "column_header", :partial => "edit_labels"
    end
  end

  def update_labels
    @production_plan = ProductionPlan.find params[:id]
    @production_plan.update_attribute :column_labels, params[:column_labels]
    flash[:notice] = "Production Plan Column Labels updated"
    return redirect_to production_plan_path(@production_plan)
  end
end
