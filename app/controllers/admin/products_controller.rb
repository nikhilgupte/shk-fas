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
    @products = Product.all(:select => 'products.name as "Product Name", products.code as "Product Code", formulations.name as "Formulation Name", formulations.code as "Forum Code"', :joins => :formulation)
    #response.headers['Content-Disposition'] = "attachment; filename=\"product_mappings#{Date.today.to_s(:date).gsub(/\W/,'_')}.csv\""
    #return render :text => @products.collect{|p| ([p["pn"], p["pc"], p["fn"], p["fc"]]).to_csv}.insert(0, (['product name','product code','formulation name','formulation code']).to_csv).join
    send_data @products.to_csv(:encoding => 'u'),
      { :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=products_mapping_#{Date.today.to_s(:date).gsub(/\W/,'_')}.csv" }
  end
end
