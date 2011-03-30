class IngredientsController < ApplicationController
  def index
    @title = "Lookup Ingredients" 
  end

  def show
    @ingredient = Ingredient.find params[:id]
    if request.xhr?
      render :update do |p|
        p.replace_html "ingredient", :partial => "show"
      end
      return
    else
      @title = "#{@ingredient.name} - #{@ingredient.code}"
    end
  end

  def export
    if request.format == Mime::CSV
        since = params[:since].present? ? DateTime.parse(params[:since]) : Date.parse('1 Jan 2009')
        currencies = Currency.all.to_a
        @ingredients = Ingredient.updated_since(since).map do |ing|
          [ ["Code", ing.code], ["Name", ing.name] ].tap do |a|
            if(latest_price = ing.latest_price).present?
              currencies.each do |c|
                a << [c.name, latest_price.send(c.name.downcase).round(2)]
              end
              a << ["Updated by", latest_price.user]
              a << ["Updated on", latest_price.created_at.to_s(:datetime)]
            end
          end
        end
        send_data @ingredients.to_csv(:encoding => 'u'),
          { :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=ingredients_#{since.to_s(:date).gsub(/\W/,'_')}.csv" }

        ExportLog.create! :user => @logged_in_user
    else
      @title = 'Export Ingredients'
    end
  end


  def auto_complete_for_ingredient_name
    arg = params[:ingredient_name]
    arg.downcase!
    @ingredients = Ingredient.live.find(:all, :conditions => ['lower(name) like ?', "%#{arg}%"], :limit => 10)
    render :partial => 'ingredients_auto_complete.html.erb'
  end

end
