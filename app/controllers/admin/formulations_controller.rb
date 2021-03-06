class Admin::FormulationsController < AdminController
  active_scaffold :formulations do |config|
    config.actions.exclude :delete, :show
    config.action_links.add :import, :label => "Import", :inline => false
    config.columns.exclude :created_at
  end

  def import
    if request.post?
      added,updated = 0,0
      @errors = []
      begin
        cd = Iconv.new('utf-8', 'iso-8859-1')
        line_number = 1
        FasterCSV.parse(params[:formulations_file].read.chop, {:headers =>true,:skip_blanks => true}) do |row|
          line_number += 1
          code,name,standard_quantity = row[0].strip, cd.iconv(row[1]).strip, cd.iconv(row[2]).strip
          unless code.blank? || name.blank?
            if formulation = Formulation.find_by_code(code)
              #formulation.update_attribute(:name, name)
              formulation.name = name
              formulation.standard_quantity = standard_quantity if standard_quantity.present?
              formulation.save
              updated += 1
            else
              formulation = nil
              begin
                formulation = Formulation.create!(:code => code, :name => name, :standard_quantity => standard_quantity)
                added += 1
              rescue
                @errors << { :line_number => line_number, :message => $!.to_s, :code => code, :name => name }
              end
            end
          end
        end
      end
      flash.now[:notice] = "Added #{added} and updated #{updated} formulations."
      render :imported
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
