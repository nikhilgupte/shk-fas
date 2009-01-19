ActionController::Routing::Routes.draw do |map|
 
  map.resources :orders, :collection => {:auto_complete_for_order_product_name_or_code => :any, :export => :any}

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
