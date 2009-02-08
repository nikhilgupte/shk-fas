class Admin::TaxRatesController < AdminController
  active_scaffold :tax_rates do |config|
    config.actions.exclude :search, :delete, :show
    config.columns.exclude :created_at
    #config.columns.exclude :profiles
  end
end
