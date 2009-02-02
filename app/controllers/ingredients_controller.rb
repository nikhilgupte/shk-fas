class IngredientsController < ApplicationController
  def index
    @title = "Lookup Ingredients" 
  end

  def show
    @ingredient = Ingredient.find params[:id]
    @title = "#{@ingredient.name} - #{@ingredient.code}"
  end

  def export
    @ingredients = Ingredient.live
    response.headers['Content-Type'] = 'application/force-download'
    response.headers['Content-Disposition'] = "attachment; filename=\"ingredients-#{Time.now.to_s(:date).gsub(/\W/,'-')}.csv\""
    render :text => @ingredients.collect{|i| ([i.id, i.code] + CURRENCIES.collect{|c| i.price(c)}).to_csv}.join
  end

  def auto_complete_for_ingredient_name
    arg = params[:ingredient_name]
    arg.downcase!
    @ingredients = Ingredient.live.find(:all, :conditions => ['lower(name) like ?', "#{arg}%"], :limit => 10)
    render :partial => 'ingredients_auto_complete'
  end

end
