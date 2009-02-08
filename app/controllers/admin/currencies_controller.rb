class Admin::CurrenciesController < AdminController
  active_scaffold :currency do |config|
    config.actions.exclude :search, :delete, :show, :create
    config.list.columns = [:name, :inr_value]
  end

end
