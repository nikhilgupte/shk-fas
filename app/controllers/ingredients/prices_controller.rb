class Ingredients::PricesController < ApplicationController
  before_filter :load_ingredient

  def create
    @price = @ingredient.prices.build(params[:ingredient_price].merge!(:user_id => @logged_in_user.id))
    if @price.save
      render :update do |page|
        flash[:notice] = "New price in #{@price.currency} added."
        page.redirect_to ingredient_path(@ingredient)
      end
    else
      render :update do |page|
        page.alert(@price.errors.full_messages)
      end
    end
  end

  private
  def load_ingredient
    @ingredient = Ingredient.find params[:ingredient_id]
  end
end
