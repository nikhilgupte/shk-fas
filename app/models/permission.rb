#++
#
# Each User is assigned Permissions to grant them access to modules/operations.
# Permissions are modeled as a combination of modules (mapped to controllers)
# and operations (mapped to controllers' actions).
class Permission < ActiveRecord::Base
  @@permission_map = {}
  def self.map_permissions(module_name, operations)
    @@permission_map[module_name] = {}
    operations.each do |operation, actions|
      actions = [*actions] unless actions.is_a?(Array)
      actions.each{|a| @@permission_map[module_name][a.to_sym] = operation.to_sym} 
    end
  end

  map_permissions 'orders', :write => [:index, :submit, :create, :edit, :update, :destroy], :export => :export
  map_permissions 'ingredients', :read => [:index, :show], :export => :export
  map_permissions 'ingredients/prices', :write => [:create]
  map_permissions 'admin/ingredients', :read => [:index, :show], :write => [:edit, :new, :create, :update]
  map_permissions 'admin/products', :read => [:index, :show], :write => [:edit, :new, :create, :update]
  map_permissions 'admin/currencies', :read => [:index, :show], :write => [:edit, :new, :create, :update]
  map_permissions 'admin/tax_rates', :read => [:index, :show], :write => [:edit, :new, :create, :update]
  map_permissions 'admin/custom_duties', :read => [:index, :show], :write => [:edit, :new, :create, :update]
  map_permissions 'admin/users', :read => [:index, :show], :write => [:edit, :new, :create, :update, :modify_permissions, :toggle_disable]
  #map_permissions 'production_plans', :read => [:index, :show], :write => [:edit, :new, :create, :update], :export => :export

  # Gets the operation for a given module/controller and action
  def self.operation(module_name, action)
    @@permission_map[module_name][action.to_sym] rescue nil
  end

  def self.module_names
    @@permission_map.keys
  end

  def self.operations(module_name = nil)
    unless module_name
      [:read, :write, :export]
    else
      @@permission_map[module_name].values.uniq
    end
  end

  def self.grant_all(username)
    user = User.find_by_username(username)
    user.permissions.delete_all
    module_names.each do |module_name|
      operations(module_name).each{|op|
        user.permissions.create(:module => module_name, :operation => op.to_s)
      }
    end
  end
end
