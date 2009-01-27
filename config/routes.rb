ActionController::Routing::Routes.draw do |map|
 
  map.resources :orders, :collection => {:auto_complete_for_order_product_name_or_code => :any, :export => :get, :submit => :post}
  #map.resources :ingredients, :collection => {:auto_complete_for_ingredient_name => :get, :export => :get}, :has_many => :prices
  map.resources :ingredients, :collection => {:auto_complete_for_ingredient_name => :get, :export => :get} do |ingredient|
    ingredient.resources :ingredient_prices, :controller => 'ingredients/prices', :as => "prices"
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
