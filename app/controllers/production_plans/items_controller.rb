class ProductionPlans::ItemsController < ApplicationController
  before_filter :load_plan

  def create
    @item = @production_plan.items.build params[:production_plan_item]
    render :update do |page|
      if @item.save
        page <<  "if($('items_empty')) Element.remove('items_empty')"
        page.insert_html :top, 'items', :partial => 'show', :locals => {:item => @item}
        @production_plan.items.each do |item|
          page.replace "item_#{item.id}", :partial => 'show', :locals => {:item => item}
        end
        @item = nil
      end
      page.replace 'item_form', :partial => 'form'
    end
  end

  def destroy
    @production_plan.items.find(params[:id]).delete
    render :update do |page|
      @production_plan.items.each do |item|
        page.replace "item_#{item.id}", :partial => 'show', :locals => {:item => item}
      end
    end
  end

  private
  def load_plan
    @production_plan = ProductionPlan.find params[:production_plan_id]
  end
end
