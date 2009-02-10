class IngredientsController < ApplicationController
  def index
    @title = "Lookup Ingredients" 
  end

  def show
    @ingredient = Ingredient.find params[:id]
    @title = "#{@ingredient.name} - #{@ingredient.code}"
  end

  def export
    if request.format == Mime::CSV
        since = DateTime.parse params[:since] if params[:since]
        @ingredients = since.nil? ? Ingredient.updated_since(Date.parse('1 Jan 2009')) : Ingredient.updated_since(since)
        response.headers['Content-Type'] = 'application/force-download'
        response.headers['Content-Disposition'] = "attachment; filename=\"ingredients#{'-'+since.to_s(:date).gsub(/\W/,'-') if since}.csv\""
        return render :text => @ingredients.collect{|i| ([i.code] + Currency.all.collect{|c| i.latest_price.send(c.name.downcase).round(2)} + [i.latest_price.user.username, i.latest_price.created_at.to_s(:datetime)]).to_csv}.insert(0, (['code'] + Currency.all.collect{|c| c.name} + %w(user updated_on)).to_csv).join
    else
      @title = 'Export Ingredients'
    end
  end


  def auto_complete_for_ingredient_name
    arg = params[:ingredient_name]
    arg.downcase!
    @ingredients = Ingredient.live.find(:all, :conditions => ['lower(name) like ?', "#{arg}%"], :limit => 10)
    render :partial => 'ingredients_auto_complete.html.erb'
  end

end
