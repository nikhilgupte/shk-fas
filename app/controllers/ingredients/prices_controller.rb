class Ingredients::PricesController < ApplicationController
  before_filter :load_ingredient

  def create
    @price = @ingredient.prices.build(params[:ingredient_price].merge!(:user_id => @logged_in_user.id))
    if @price.save
      render :update do |page|
        flash[:notice] = "New prices added."
        page.redirect_to ingredient_path(@ingredient)
      end
    else
      render :update do |page|
        page.replace_html :prices_form, :partial => 'ingredients/prices/form'
      end
    end
  end

  private
  def load_ingredient
    @ingredient = Ingredient.find params[:ingredient_id]
  end
end
