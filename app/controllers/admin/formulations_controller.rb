class Admin::FormulationsController < AdminController
  active_scaffold :formulations do |config|
    config.actions.exclude :delete, :show
    config.action_links.add :import, :label => "Import", :inline => false
    config.columns.exclude :created_at
  end

  def import
    if request.post?
      begin
        FasterCSV.parse(params[:formulations_file].read.chop, {:headers =>true,:skip_blanks => true}) do |row|
          code,name = row[0],row[1]
          unless code.blank? || name.blank?
            if formulation = Formulation.find_by_code(code)
              formulation.update_attribute(:name, name)
            else
              Formulation.create!(:code => code, :name => name)
            end
          end
        end
      #rescue
      end
    end
  end

  def auto_complete_formulations
    arg = params[:formulation_name]
    arg.downcase!
    @formulations = Formulation.find(:all, :conditions => ['lower(name) like ? or lower(code) like ?', "%#{arg}%", "#{arg}%"], :limit => 10)
    render :partial => 'formulations_auto_complete'
  end

end
