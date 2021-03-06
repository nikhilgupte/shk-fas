class Admin::IngredientsController < AdminController
  active_scaffold :ingredients do |config|
    config.action_links.add :import, :label => "Import Ingredients", :inline => false
    config.action_links.add :import_prices, :label => "Import Prices", :inline => false
    config.actions.exclude :delete, :show
    config.columns.exclude :created_at, :prices
    config.columns[:tax_rate].form_ui = :select
    config.columns[:custom_duty].form_ui = :select
    config.actions.exclude :nested
  end

  def import
    if request.post?
      added,updated = 0,0
      @errors = []
      cd = Iconv.new('utf-8', 'iso-8859-1')
      line_number = 1
      FasterCSV.parse(params[:ingredients_file].read.chop, {:headers =>true,:skip_blanks => true}) do |row|
        code,name = row[0].strip, cd.iconv(row[1]).strip
        line_number += 1
        begin
          unless code.blank? || name.blank?
            if ingredient= Ingredient.find_by_code(code)
              ingredient.update_attribute(:name, name)
              updated += 1
            else
              Ingredient.create!(:code => code, :name => name, :import_mode => true)
              added += 1
            end
          end
        rescue
          @errors << { :line_number => line_number, :message => $!.to_s, :code => code, :name => name }
        end
      end
      flash.now[:notice] = "Added #{added} and updated #{updated} ingredients."
      render :imported
    end
    @title = 'Admin: Ingredients: Import'
  end

  def import_prices
    if request.post?
      imported = 0
      @errors = []
      cd = Iconv.new('utf-8', 'iso-8859-1')
      line_number = 1
      FasterCSV.parse(params[:ingredient_prices_file].read.chop, {:headers =>true,:header_converters => :symbol, :skip_blanks => true}) do |row|
        code = row[:ingredient_code].try(:strip)
        date = row[:date].try(:strip)
        inr = row[:inr].try(:strip)
        usd = row[:usd].try(:strip)
        eur = row[:eur].try(:strip)
        line_number += 1
        begin
          unless code.blank?
            if ingredient= Ingredient.find_by_code(code)
              date = Date.strptime(date, '%Y-%m-%d') rescue raise('Invalid date')
              ingredient.prices.delete_prices_for(date)
              ingredient.prices.create!(:created_at => date, :price_in_inr => inr, :price_in_usd => usd, :price_in_eur => eur, :user_id => @logged_in_user.id, :force => 'true')
              imported += 1
            else
              raise "Ingredient not found!"
            end
          end
        rescue
          @errors << { :line_number => line_number, :message => $!.to_s, :code => code, :date => date }
        end
      end
      flash.now[:notice] = "Imported #{imported} prices."
      render :imported_prices
    end
    @title = 'Admin: Ingredients: Import Prices'
  end

end
