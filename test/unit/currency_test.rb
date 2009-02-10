require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  def test_basic_conversion
    assert 10.usd_in_inr == 500
    assert 10.eur_in_inr == 600
    assert 500.inr_in_usd == 10
    assert 600.inr_in_eur == 10
  end
end
