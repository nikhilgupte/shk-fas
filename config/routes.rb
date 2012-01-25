ActionController::Routing::Routes.draw do |map|
 
  map.resources :orders, :collection => {:auto_complete_for_order_product_name_or_code => :any, :export => :get, :submit => :post}
  map.export_prices 'ingredients/export_prices.:format', :controller => 'ingredients/prices', :action => 'export'
  map.resources :ingredients, :collection => {:auto_complete_for_ingredient_name => :get, :export => :any} do |ingredient|
    ingredient.resources :ingredient_prices, :controller => 'ingredients/prices', :as => "prices"
  end

  map.resources :production_plans, :collection => {:auto_complete_for_item_product_name_or_code => :any},
      :member => {:copy => :post, :submit => :post, :bom => :get, :upload_bom => :post, :delete_bom => :delete, :edit_labels => :post, :update_labels => :post} do |production_plan|
    production_plan.resources :production_plan_items, :as => "items", :controller => "production_plans/items", :collection => {:pre_populate => :post, :import => :post}
  end

  map.namespace :admin do |admin|
    %w(tax_rates custom_duties products ingredients currencies formulations).each do |m|
      admin.send(m, "#{m}/:action", :controller => m)
    end
    admin.resources :users, :member => {:toggle_disable => :post, :modify_permissions => :post}
  end

  map.admin 'admin/:action', :controller => 'admin'


  map.account '/:action', :controller => 'account', :action => 'home'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
