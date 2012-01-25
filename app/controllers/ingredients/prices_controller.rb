class Ingredients::PricesController < ApplicationController
  before_filter :load_ingredient, :except => [:export]

  def create
    @price = @ingredient.prices.build(params[:ingredient_price].merge!(:user_id => @logged_in_user.id))
    if @price.save
      render :update do |page|
        @price = IngredientPrice.new
        flash.now[:notice] = "New prices added."
        page.replace_html :ingredient_msg, :partial => 'common/flash_message'
        page.replace_html :ingredient, :partial => 'ingredients/show'
      end
    else
      render :update do |page|
        page.replace_html :prices_form, :partial => 'ingredients/prices/form'
      end
    end
  end

  def export
    if request.format == Mime::CSV
        since = params[:since].present? ? DateTime.parse(params[:since]) : Date.parse('1 Jan 2009')
        @prices = IngredientPrice.export(since)
        send_data @prices.to_csv(:encoding => 'u'),
          { :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=ingredient_prices_#{since.to_s(:date).gsub(/\W/,'_')}.csv" }

        ExportLog.create! :user => @logged_in_user
    else
      @title = 'Export Prices'
    end
  end

  private
  def load_ingredient
    @ingredient = Ingredient.find params[:ingredient_id]
  end
end
