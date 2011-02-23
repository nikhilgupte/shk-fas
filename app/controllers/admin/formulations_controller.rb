class Admin::FormulationsController < AdminController
  active_scaffold :formulations do |config|
    config.actions.exclude :delete, :show
    config.action_links.add :import, :label => "Import", :inline => false
    config.columns.exclude :created_at
  end

  def import
    if request.post?
      added,updated = 0,0
      begin
        cd = Iconv.new('utf-8', 'iso-8859-1')
        FasterCSV.parse(params[:formulations_file].read.chop, {:headers =>true,:skip_blanks => true}) do |row|
          code,name = row[0], cd.iconv(row[1])
          unless code.blank? || name.blank?
            if formulation = Formulation.find_by_code(code)
              formulation.update_attribute(:name, name)
              updated += 1
            else
              Formulation.create!(:code => code, :name => name)
              added += 1
            end
          end
        end
      #rescue
      end
      flash[:notice] = "Added #{added} and updated #{updated} formulations."
      redirect_to admin_formulations_path
    end
    @title = 'Admin: Formulations: Import'
  end

  def auto_complete_formulations
    arg = params[:formulation_name]
    arg.downcase!
    @formulations = Formulation.find(:all, :conditions => ['lower(name) like ? or lower(code) like ?', "%#{arg}%", "%#{arg}%"], :limit => 10)
    render :partial => 'formulations_auto_complete'
  end

end
