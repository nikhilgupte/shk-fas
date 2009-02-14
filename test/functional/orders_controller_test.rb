require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  def test_index
    user = users(:test1)
    get :index, {}, {:logged_in_user_id, user.id}
    assert_response :unauthorized
    assert_valid user.permissions.create(:module => 'orders', :operation => 'write')
    get :index, {}, {:logged_in_user_id, user.id}
    assert_response :success
  end

  def test_create
    user = users(:test1)
    product = products(:product1)
    get :create, {:order => {:product_id => product.id, :quantity => 100}}, {:logged_in_user_id, user.id}
    assert_response :unauthorized

    assert_valid user.permissions.create(:module => 'orders', :operation => 'write')
    get :create, {:order => {:product_id => product.id, :quantity => 100}}, {:logged_in_user_id, user.id}
    assert_response :success
  end

  def test_export
    user = users(:test1)
    assert_valid user.permissions.create(:module => 'orders', :operation => 'write')
    get :export, {}, {:logged_in_user_id, user.id}
    assert_response :unauthorized

    assert_valid user.permissions.create(:module => 'orders', :operation => 'export')
    get :export, {}, {:logged_in_user_id, user.id}
    assert_response :success
  end

end
