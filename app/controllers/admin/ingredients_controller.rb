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
      begin
        FasterCSV.parse(params[:ingredients_file].read.chop, {:headers =>true,:skip_blanks => true}) do |row|
          code,name = row[0],row[1]
          unless code.blank? || name.blank?
            if ingredient= Ingredient.find_by_code(code)
              ingredient.update_attribute(:name, name)
              updated += 1
            else
              Ingredient.create!(:code => code, :name => name, :import_mode => true)
              added += 1
            end
          end
        end
      #rescue
      end
      flash[:notice] = "Added #{added} and updated #{updated} ingredients."
      redirect_to admin_ingredients_path
    end
    @title = 'Admin: Ingredients: Import'
  end

end
