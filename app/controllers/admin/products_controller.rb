class Admin::ProductsController < AdminController
  active_scaffold :products do |config|
    config.actions.exclude :delete, :show
    config.action_links.add :import, :label => "Import", :inline => false
    config.action_links.add :export_mapped, :label => "Export Mappings", :inline => false
    config.action_links.add :export, :label => "Export All", :inline => false
    config.columns.exclude :created_at, :formulation
    config.list.columns.add :formulation
    config.columns.add :formulation_id
    config.list.columns.exclude :formulation_id
    config.columns[:formulation].clear_link
  end

  def import
    if request.post?
      added,updated = 0,0
      @errors = []
      begin
        cd = Iconv.new('utf-8', 'iso-8859-1')
        line_number = 1
        FasterCSV.parse(params[:products_file].read.chop, {:headers =>true,:skip_blanks => true}) do |row|
          line_number += 1
          code,name = row[0].strip, cd.iconv(row[1]).strip
          unless code.blank? || name.blank?
            if product = Product.find_by_code(code)
              product.update_attribute(:name, name)
              updated += 1
            else
              product = nil
              begin
                product = Product.create!(:code => code, :name => name)
                added += 1
              rescue
                @errors << { :line_number => line_number, :message => $!.to_s, :code => code, :name => name }
              end
            end
          end
        end
      end
      flash.now[:notice] = "Added #{added} and updated #{updated} products."
      render :imported
    end
    @title = 'Admin: Products: Import'
  end


  def export_mapped
    export(true)
  end

  def export(mapped = false)
    scope = Product.mapped
    if mapped
      scope = scope.scoped(:conditions => "formulation_id is not null")
    end
    @products = scope.map{|p| [
        ["Product Name", p.name],
        ["Product Code", p.code],
        ["Formulation Name", (p.formulation_name rescue nil)],
        ["Formulation Code", (p.formulation_code rescue nil)]
      ]
    }
    send_data @products.to_csv(:encoding => 'u'),
      { :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=products_mapping_#{Date.today.to_s(:date).gsub(/\W/,'_')}.csv" }
  end
end
