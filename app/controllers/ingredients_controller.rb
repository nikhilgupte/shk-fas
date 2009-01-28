class IngredientsController < ApplicationController
  def index
    @title = "Lookup Ingredients" 
  end

  def show
    @ingredient = Ingredient.find params[:id]
    @title = "#{@ingredient.name} - #{@ingredient.code}"
  end

  def auto_complete_for_ingredient_name
    arg = params[:ingredient_name]
    arg.downcase!
    @ingredients = Ingredient.live.find(:all, :conditions => ['lower(name) like ?', "#{arg}%"], :limit => 10)
    render :partial => 'ingredients_auto_complete'
  end

end
