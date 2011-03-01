class Admin::IngredientsController < AdminController
  active_scaffold :ingredients do |config|
    config.action_links.add :import, :label => "Import", :inline => false
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
      flash[:notice] = "Added #{added} and updated #{updated} ingredients."
      redirect_to admin_ingredients_path unless @errors.present?
    end
    @title = 'Admin: Ingredients: Import'
  end

end
