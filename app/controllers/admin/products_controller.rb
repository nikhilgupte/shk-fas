class Admin::ProductsController < AdminController
  active_scaffold :products do |config|
    config.actions.exclude :delete, :show
    config.action_links.add :export, :label => "Export Mappings", :inline => false
    config.columns.exclude :created_at, :formulation
    config.list.columns.add :formulation
    config.columns.add :formulation_id
    config.list.columns.exclude :formulation_id
    config.columns[:formulation].clear_link
  end

  def export
    @products = Product.mapped.all.map{|p| [
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
