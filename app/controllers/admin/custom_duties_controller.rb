class Admin::CustomDutiesController < AdminController
  active_scaffold :custom_duties do |config|
    config.actions.exclude :search, :delete, :show
    config.columns.exclude :created_at
  end
end
