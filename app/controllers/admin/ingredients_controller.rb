class Admin::IngredientsController < AdminController
  active_scaffold :ingredients do |config|
    config.actions.exclude :delete, :show
    config.columns.exclude :created_at, :prices
    config.columns[:tax_rate].ui_type = :select
    config.columns[:custom_duty].ui_type = :select
    config.actions.exclude :nested
  end
end
