ActionController::Routing::Routes.draw do |map|
 
  map.account 'account/:action', :controller => 'account'

  map.resources :orders, :collection => {:auto_complete_for_order_product_name_or_code => :any, :export => :get, :submit => :post}
  map.resources :ingredients, :collection => {:auto_complete_for_ingredient_name => :get, :export => :any} do |ingredient|
    ingredient.resources :ingredient_prices, :controller => 'ingredients/prices', :as => "prices"
  end

  map.namespace :admin do |admin|
    %w(tax_rates custom_duties products ingredients currencies).each do |m|
      admin.send(m, "#{m}/:action", :controller => m)
    end
    admin.resources :users, :member => {:toggle_disable => :post}
  end

  map.admin 'admin/:action', :controller => 'admin'


  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
