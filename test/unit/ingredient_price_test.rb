require 'test_helper'

class IngredientPriceTest < ActiveSupport::TestCase
  def test_basic_validation
    ingredient = ingredients(:i1)
    assert !ingredient.prices.build.valid?
    assert ingredient.prices.build(:price_in_inr => 10).valid?
    assert ingredient.prices.build(:price_in_usd => 10).valid?
    assert ingredient.prices.build(:price_in_eur => 10).valid?
  end

  def test_acceptable_fluctuations
    ingredient = ingredients(:i1)
    price = ingredient.prices.create(:price_in_inr => 100, :price_in_usd => 100, :price_in_eur => 100)
    assert ingredient.prices.build(:price_in_inr => 101).valid?
    assert ingredient.prices.build(:price_in_inr => 110).valid?
    assert ingredient.prices.build(:price_in_inr => 90).valid?

    assert !ingredient.prices.build(:price_in_inr => 111).valid?
    assert ingredient.prices.build(:price_in_inr => 111, :force => 'true').valid?

    assert ingredient.prices.build(:price_in_usd => 90).valid?
    assert ingredient.prices.build(:price_in_usd => 110).valid?
    usd_price =  ingredient.prices.build(:price_in_usd => 111)
    assert !usd_price.valid?
    assert usd_price.errors.invalid?(:price_in_usd)
    assert ingredient.prices.build(:price_in_usd => 111, :force => 'true').valid?

    assert ingredient.prices.build(:price_in_eur => 90).valid?
    assert ingredient.prices.build(:price_in_eur => 110).valid?
    eur_price =  ingredient.prices.build(:price_in_eur => 111)
    assert !eur_price.valid?
    assert eur_price.errors.invalid?(:price_in_eur)
    assert ingredient.prices.build(:price_in_eur => 111, :force => 'true').valid?
  end

  def test_acceptable_fluctuations_with_derivied_usd
    ingredient = ingredients(:i1)
    price = ingredient.prices.create(:price_in_inr => 5000)
    assert price.valid?
    assert_equal 100, price.base_usd
    assert ingredient.prices.build(:price_in_usd => 90).valid?
    assert ingredient.prices.build(:price_in_usd => 110).valid?
    usd_price =  ingredient.prices.build(:price_in_usd => 111)
    assert !usd_price.valid?
    assert usd_price.errors.invalid?(:price_in_usd)
    assert ingredient.prices.build(:price_in_usd => 111, :force => 'true').valid?
  end

  def test_acceptable_fluctuations_with_derivied_eur
    ingredient = ingredients(:i1)
    price = ingredient.prices.create(:price_in_inr => 6000)
    assert price.valid?
    assert_equal 100, price.base_eur
    assert ingredient.prices.build(:price_in_eur => 90).valid?
    assert ingredient.prices.build(:price_in_eur => 110).valid?
    eur_price =  ingredient.prices.build(:price_in_eur => 111)
    assert !eur_price.valid?
    assert eur_price.errors.invalid?(:price_in_eur)
    assert ingredient.prices.build(:price_in_eur => 111, :force => 'true').valid?
  end

end
