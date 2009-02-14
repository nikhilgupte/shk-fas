require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def test_order_prod_qty
    order = users(:test1).orders.build(:quantity => 100)
    order.valid?
    assert_equal order.quantity, order.production_quantity, 'if blank production quantity must default to order quantity'
    order = users(:test1).orders.build(:quantity => 100, :production_quantity => 99)
    order.valid?
    assert order.errors.invalid?(:production_quantity), 'production_quantity cannot be less than order quantity'
  end

  def test_order_uniqueness
    user = users(:test1)
    product = products(:product1)
    order = user.orders.create(:quantity => 100, :product_id => product.id)
    assert_valid order
    assert_equal 1, user.orders.pending.count
    order = user.orders.create(:quantity => 100, :product_id => product.id, :location => 'm')
    assert !order.valid?
    assert_not_nil order.errors.on_base

    order = user.orders.create(:quantity => 100, :product_id => product.id, :location => 'k')
    assert_nil order.errors.on_base, 'Orders in location KEVA are not grouped with the rest for uniqueness'
    order = user.orders.create(:quantity => 101, :product_id => product.id, :location => 'k')
    assert_not_nil order.errors.on_base, 'Orders in location KEVA must be unique'
  end

end
