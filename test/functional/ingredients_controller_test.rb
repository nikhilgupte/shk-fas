require 'test_helper'

class IngredientsControllerTest < ActionController::TestCase
  def test_index
    user = users(:test1)
    get :index, {}, {:logged_in_user_id, user.id}
    assert_response :unauthorized
    assert_valid user.permissions.create(:module => 'ingredients', :operation => 'read')
    get :index, {}, {:logged_in_user_id, user.id}
    assert_response :success
  end

  def test_show
    user = users(:test1)
    ingredient = ingredients(:i1)
    get :show, {:id => ingredient.id}, {:logged_in_user_id, user.id}
    assert_response :unauthorized
    assert_valid user.permissions.create(:module => 'ingredients', :operation => 'read')
    get :show, {:id => ingredient.id}, {:logged_in_user_id, user.id}
    assert_response :success
  end

  def test_export
    user = users(:test1)
    assert_valid user.permissions.create(:module => 'ingredients', :operation => 'read')
    get :export, {}, {:logged_in_user_id, user.id}
    assert_response :unauthorized

    assert_valid user.permissions.create(:module => 'ingredients', :operation => 'export')
    get :export, {}, {:logged_in_user_id, user.id}
    assert_response :success
  end

  def test_export_csv
    user = users(:test1)
    assert_valid user.permissions.create(:module => 'ingredients', :operation => 'export')
    get :export, {:format => 'csv'}, {:logged_in_user_id, user.id}
    assert_response :success
  end

end
