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
    @products = Product.connection.execute("select products.name as pn, products.code as pc, formulations.name as fn, formulations.code as fc from products inner join formulations on formulations.id = products.formulation_id")
    response.headers['Content-Disposition'] = "attachment; filename=\"product_mappings#{Date.today.to_s(:date).gsub(/\W/,'_')}.csv\""
    return render :text => @products.collect{|p| ([p["pn"], p["pc"], p["fn"], p["fc"]]).to_csv}.insert(0, (['product name','product code','formulation name','formulation code']).to_csv).join
  end
end
