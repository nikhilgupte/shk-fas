class Admin::ProductsController < AdminController
  active_scaffold :products do |config|
    config.actions.exclude :delete, :show
    config.columns.exclude :created_at, :formulation
    config.list.columns.add :formulation
    config.columns.add :formulation_id
    config.list.columns.exclude :formulation_id
    config.columns[:formulation].clear_link
  end
end
