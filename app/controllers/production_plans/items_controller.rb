class ProductionPlans::ItemsController < ApplicationController
  before_filter :load_plan

  def create
    @item = @production_plan.items.build params[:production_plan_item]
    if old_item = @production_plan.items.find(:first, :conditions => "product_id = #{@item.product_id}")
      old_item.delete
    end
    render :update do |page|
      if @item.save
        page <<  "if($('items_empty')) Element.remove('items_empty')"
        page.insert_html :top, 'items', :partial => 'show', :locals => {:item => @item}
        page.remove "item_#{old_item.id}" if old_item
        @production_plan.items.each do |item|
          page.replace "item_#{item.id}", :partial => 'show', :locals => {:item => item}
        end
        page.visual_effect :highlight, "item_#{@item.id}"
        page.replace "items_totals_#{@production_plan.id}", :partial => "/production_plans/items_totals"
        @item = nil
      end
      page.replace 'item_form', :partial => 'form'
    end
  end

  def edit
    @item = @production_plan.items.find(params[:id])
    render :update do |p|
      p.replace "item_#{@item.id}", :partial => 'edit'
    end
  end

  def update
    @item = @production_plan.items.find(params[:id])
    render :update do |page|
      if @item.update_attributes(params[:production_plan_item])
        @production_plan.items.each do |item|
          page.replace "item_#{item.id}", :partial => 'show', :locals => {:item => item}
        end
        page.replace "items_totals_#{@production_plan.id}", :partial => "/production_plans/items_totals"
        page.visual_effect :highlight, "item_#{@item.id}"
      else
        page.replace "item_#{@item.id}", :partial => 'edit'
      end
    end
  end

  def destroy
    @production_plan.items.find(params[:id]).delete
    render :update do |page|
      @production_plan.items.each do |item|
        page.replace "item_#{item.id}", :partial => 'show', :locals => {:item => item}
      end
      page.replace "items_totals_#{@production_plan.id}", :partial => "/production_plans/items_totals"
    end
  end

  def pre_populate
    if @item = @production_plan.items.find_by_product_id(params[:id].to_i)
      render :update do |p|
        (1..4).each{|i| p["production_plan_item_quantity_#{i}"].value = @item.quantity(i)}
        p["product_error_msg"].innerHTML = "Product alread present in plan. Overwrite?"
        p["add_item_button"].value = "Update"
      end
    else
      render :nothing => true
    end
  end

  def import
    added,updated,line_number = 0,0,1
    begin
      raise "Choose a CSV file to upload." unless params[:file]
      FasterCSV.parse(params[:file].read.chop, {:headers =>true,:skip_blanks => true}) do |row|
        line_number += 1
        code,qty1,qty2,qty3,qty4 = row[0], row[2], row[3], row[4], row[5]
        if code.present? && (product = Product.find_by_code(code))
          if item = @production_plan.items.find_by_product_id(product.id)
            item.attributes = { :quantity_1 => qty1, :quantity_2 => qty2, :quantity_3 => qty3, :quantity_4 => qty4 }
            item.save!
            updated += 1
          else
            @production_plan.items.create!(:product_id => product.id, :quantity_1 => qty1, :quantity_2 => qty2, :quantity_3 => qty3, :quantity_4 => qty4)
            added += 1
          end
        end
      end
      flash[:notice] = "Added #{added} and updated #{updated} products."
      redirect_to @production_plan
    rescue
      flash[:error] = "Error line# #{line_number}: #{$!}"
      redirect_to @production_plan
    end
  end

  private
  def load_plan
    @production_plan = ProductionPlan.find params[:production_plan_id]
  end
end
