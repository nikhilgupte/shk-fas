require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  test "Get operation for an action" do
    assert_equal :read, Permission.operation('ingredients', :index)
    assert_equal :read, Permission.operation('ingredients', 'index'), 'should also work with action as a string'
    assert_nil Permission.operation('DOES_NOT_EXIST', :index), "should not cause an error if module isn't found"
    assert_nil Permission.operation('orders', 'does_no_exist'), "shoul not cause an error if action isn't found"
  end

  test "Grant All" do
    assert !users(:test1).is_permitted?('ingredients', :read)
    Permission.grant_all('test1')
    assert users(:test1).is_permitted?('ingredients', :read)
  end

  test "code coverage" do
    assert Permission.module_names
    assert Permission.operations
    assert Permission.operations('ingredients')
  end
end
