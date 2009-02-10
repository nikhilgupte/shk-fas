class Admin::ProductsController < AdminController
  active_scaffold :products do |config|
    config.actions.exclude :delete, :show
    config.columns.exclude :created_at
    #config.columns.exclude :profiles
  end
end
